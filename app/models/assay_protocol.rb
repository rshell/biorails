# This links a protocol_version into a Assay as a Protocol to be run in the assay
# There are a number of sub types of a AssayProtocol
# Entry/ProcessDefinition with a implementation as a ProtocolVersion
# ReportDefinition this a report run in the context of a experiment
# AnalysisDefinition this is a data transformation run in the context of a experiment

 
class AssayProtocol < ActiveRecord::Base

  
  #
  # acts a dictionary indexed by name
  #
    acts_as_dictionary :name 
  #
  # Owner project
  #  
    acts_as_folder :assay  
  ##
  # This record has a full audit log created for changes 
  #   
    acts_as_audited :change_log
  #
  # free text indexing
  #
    acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
                                :description=>{:store=>:yes,:boost=>0},
                                 }, 
                     :default_field => [:name],           
                     :single_index => true, 
                     :store_class_name => true 
  ##
  # Protocol is identified by a unique name
  # 
    validates_uniqueness_of :name, :scope =>"assay_id"
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
           version.destroy unless version.used? or version.released? or version.latest?  
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
    #
    # custom conversion to xml
    #
    def to_xml(options = {})
         my_options = options.dup
         my_options[:reference] ||= {:process=>:name}
         my_options[:except] = [:process] << options[:except]
         my_options[:include] = [:versions, :stage]
        Alces::XmlSerializer.new(self, my_options ).to_s
    end

   ##
   # Get from xml
   # 
    def self.from_xml(xml,options = {})
         my_options = options.dup
         my_options[:except] = [:process] << options[:except]
         my_options[:include] = [:versions,:stage]
         Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
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
      self.versions << item 
      item.save!
      item
   end       

   
end
