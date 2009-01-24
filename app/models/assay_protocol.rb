# == Schema Information
# Schema version: 359
#
# Table name: assay_protocols
#
#  id                    :integer(4)      not null, primary key
#  assay_id              :integer(4)
#  assay_stage_id        :integer(4)
#  current_process_id    :integer(4)
#  process_definition_id :integer(4)
#  process_style         :string(128)     default("Entry"), not null
#  name                  :string(128)     default(""), not null
#  description           :string(1024)    default("")
#  literature_ref        :string(1024)    default("")
#  protocol_catagory     :string(20)
#  protocol_status       :string(20)
#  lock_version          :integer(4)      default(0), not null
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  updated_by_user_id    :integer(4)      default(1), not null
#  created_by_user_id    :integer(4)      default(1), not null
#  type                  :string(255)     default("StudyProcess"), not null
#  project_element_id    :integer(4)
#

# == Description
# This links a protocol_version into a Assay as a ProtocolVersion to be run in the assay
# There are a number of sub types of a AssayProtocol
#  * AssayProcess which describe a single step process
#  * AssayWorkflow which describe a multiple step recipe
#  
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 


 
class AssayProtocol < ActiveRecord::Base

  belongs_to :assay  
  
  #
  # acts a dictionary indexed by name
  #
    acts_as_dictionary :name 
  #
  # Owner project
  #  
    acts_as_folder_linked  :assay, :under=>'methods'
  ##
  # This record has a full audit log created for changes 
  #   
    acts_as_audited :change_log

  ##
  # Protocol is identified by a unique name
  # 
    validates_uniqueness_of :name, :scope =>"assay_id",:case_sensitive=>false
    validates_presence_of   :name
    validates_presence_of   :description
    validates_presence_of   :assay_id
    validates_presence_of   :assay_stage_id
  ##
  # Stage the protocol is linked into 
  #
  belongs_to :stage,  :class_name =>'AssayStage',:foreign_key=>'assay_stage_id'
  ##
  # The implementations are held in as a collection of versions in reverse order
  # of the version number.
  #
  has_many :versions ,
     :class_name => "ProtocolVersion",
     :order => "version desc",
     :dependent => :destroy do
     #
     # only live used versions
     #
     def live
       find(:all,:conditions=>'exists (select 1 from tasks where tasks.protocol_version_id = protocol_versions.id)')
     end

     def released
       find(:all, :conditions=>"status='released'", :order =>" version DESC")
     end
     #
     # Limit set to contexts using the the a object
     #
     def using(item,in_use=false)
       template = 'exists (select 1 from parameters where parameters.parameter_context_id=protocol_versions.id and parameters'
       if in_use
         template = "exists (select 1 from tasks where tasks.protocol_version_id = protocol_version.id) and #{template}"
       end
       case item
       when ParameterType  then  find(:all,:conditions=>["#{template}.parameter_type_id=?)" ,item.id])
       when ParameterRole  then  find(:all,:conditions=>["#{template}.parameter_role_id=?)" ,item.id])
       when AssayParameter then  find(:all,:conditions=>["#{template}.assay_parameter_id=?)",item.id])
       when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?)"    ,item.id])
       when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?)"      ,item.id])
       when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?)"   ,item.id])
       when AssayQueue     then  find(:all,:conditions=>["#{template}.assay_queue_id=?)"    ,item.id])
       else         
         return live if in_use
         find(:all)
       end  
     end 
   end

    ##
    #  has many project elements associated with it
    #  
    has_many :elements, :class_name=>'ProjectElement' ,:as => :reference,:dependent => :destroy
    #
    # tasks using this protocol
    #
    has_many :tasks, :finder_sql => ' select t.* from tasks t, protocol_versions v where t.protocol_version_id = v.id and v.assay_protocol_id= #{id}'
    ##
    # Is the default option for a number of experiments 
    #
    has_many :experiments, :dependent => :destroy

   def initialize(options={})
     super(options)
     self.assay_stage_id ||=1
     Identifier.fill_defaults(self)    
   end
   
  #
  # The project that owns this protocol
  # 
  def project
    self.assay.project if self.assay
  end 
  #
  # The team that owns this protocol
  # 
  def team
    self.assay.team if self.assay
  end 
  
  
  def multistep?
    false
  end    
  #
  # Path
  #  
  def path(scope='assay')
    case scope.to_s
    when 'root','project' then "#{assay.path(scope)}/#{self.name}"
    when 'assay' then "#{assay.name}/#{self.name}"
    else self.name
    end
  end       
  #
   def definition
    return self
   end

  ##
  # Get a Editable version of process 
  # 
   def editable
      return self.latest if self.latest.flexible?
      self.latest.copy
   end
   #
   # Remove unused versions of a protocol from the list
   #
   def purge
       ProtocolVersion.transaction do
         self.versions.each do |version|
            unless (version.latest? or version.used? or version.released?)
             logger.debug "purged process  #{version.name}"
             version.destroy
            end
         end         
       end
   end  
  # 
  # Find the next version number to use
  #   
   def next_version
     return 1 if self.new_record?
     (ProtocolVersion.maximum(:version,:conditions=>["assay_protocol_id = ?",self.id]) || 0)+1
  end
 
  #
  # Finder for visible versions of the model for the scope of the current user
  #
    def self.visible(*args)
      self.with_scope( :find => {
           :conditions=> ['exists (select 1 from memberships m,assays s where m.user_id=? and s.id=assay_protocols.assay_id and m.team_id=s.team_id)',User.current.id]
          })  do
         self.find(*args)
      end
    end 

  def process
    released || latest
  end    
  #
  # Get Current Released version of of the Protocol
  #
  def released
      @released ||=  ProtocolVersion.find(:first, :conditions=>["status='released' and assay_protocol_id = ?",self.id], :order =>" version DESC")                   
  rescue
    nil
  end    
  ##
  #Get the latest version of this AssayProtocol
  #
   def latest     
      @current ||=  ProtocolVersion.find(:first, :conditions=>["assay_protocol_id = ?",self.id], :order =>" version DESC")                   
   end
  ##
  # Get a specific version of this AssayProtocol
  # 
   def version( version)
     self.versions.detect{|i|i.version.to_s == version.to_s}
   end

   ##
   # Get the number of times all version of this protocol have been used in a task
   # 
    def usage_count
     sql = <<SQL
       select count(t.id) from tasks t,protocol_versions p,assay_protocols s
       where t.protocol_version_id =p.id
       and s.id = p.assay_protocol_id 
       and s.id = ?      
SQL
       return Task.count_by_sql( [sql ,self.id])  
    end

    def to_liquid
      AssayProtocolDrop.new self
    end

protected    
   # Create a new ProtocolVersion from this AssayProtocol
   #
   def add_version(item) 
      item.version = next_version
      item.name ||= self.name+":"+String(item.version)      
      item.protocol = self
      item.assay_protocol_id = self.id
      item.description = self.description
      if latest
        item.expected_hours = latest.expected_hours
        item.report_id = latest.report_id
        item.analysis_method_id = latest.analysis_method_id
      end
      self.versions << item 
      item.save!
      item
   end       

   
end
