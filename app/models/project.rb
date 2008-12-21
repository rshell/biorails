# == Schema Information
# Schema version: 359
#
# Table name: projects
#
#  id                 :integer(4)      not null, primary key
#  name               :string(30)      default(""), not null
#  description        :string(1024)    default(""), not null
#  status_id          :integer(4)      default(0), not null
#  title              :string(255)
#  email              :string(255)
#  host               :string(255)
#  comment_age        :integer(4)
#  timezone           :string(255)
#  started_at         :datetime
#  ended_at           :datetime
#  expected_at        :datetime
#  done_hours         :float
#  team_id            :integer(4)      not null
#  expected_hours     :float
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  project_type_id    :integer(4)      default(1)
#  parent_id          :integer(4)
#  project_element_id :integer(4)
#

# == Description
# 
# This is the only web root path and investigation log for project. The Projects
# is build of organizational elements (Assays/Protocols/Services) execution
# elements covering the capture of data (experiments/tasks) and documentation
# build of a number of sections containing articles,assets,comments,reports etc.
# 
# Then the whole system is split into a internal view managed my members of the
# project and a public view seen by subscribers.
# #
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 

class Project < ActiveRecord::Base
#
# Canned SQL filters for assays items in a protocol
#
#
  SQL_ASSAY_PROTOCOLS_EXISTS_CONDITIONS = <<-SQL
exists (select 1 from project_elements 
        where project_elements.reference_type='Assay' 
        and project_elements.reference_id=assay_protocols.assay_id
        and project_elements.project_id = ?
        and and project_elements.left_limit >= ?
        and project_elements.right_limit <= ? ) 
SQL

  SQL_PROTOCOL_VERSION_EXISTS_CONDITIONS = <<-SQL
 exists (select 1 from protocol_versions 
         inner join assay_protocols on 
             (protocol_versions.assay_protocol_id = assay_protocols.id)
         where assay_protocols.assay_id = assays.id
         and protocol_versions.status = 'released' )
SQL

  SQL_ASSAY_EXISTS_CONDITIONS = <<-SQL     
 exists ( select 1 from project_elements  
          where project_elements.reference_type='Assay'
          and project_elements.reference_id=assays.id
          and project_elements.project_id = ?
          and project_elements.left_limit >= ?
          and project_elements.right_limit <= ? ) 
SQL

  # ## Populated in Application controller with current user for the transaction
  # @todo RJS keep a eye on threading models in post 1.2 Rails to make sure this
  # keeps working
  # 
  cattr_accessor :current
  
  validates_uniqueness_of :name,:scope=>:parent_id,:case_sensitive=>false
  validates_presence_of :name
  validates_presence_of :project_type_id
  validates_presence_of :team_id
  validates_associated  :team
  validates_associated  :project_type
  validates_presence_of :description
#  validates_presence_of :title
  validates_format_of :name, :with => /^[A-Z,a-z,0-9,_,\.,\-,+,\$,\&, ,:,#]*$/, 
     :message => 'name only accept a limited range of characters [A-z,0-9,_,.,$,&,+,-, ,#,@,:]'
  before_destroy :remove_content

#
# Test if project content is used in other projects and delete if not
#
  def remove_content
    multiple_project_links_count = ProjectElement.count_by_sql( <<SQL
    select * from project_elements e
    inner join project_contents c on (e.content_id = c.id)
    where e.project_id !=c.project_id
    and c.project_id = #{self.id}
SQL
     )
    raise "Cant delete project as content used in other projects" if multiple_project_links_count > 0
    Content.delete_all "project_id = #{id}"

  end
  #
  # Add Catalog dictionary methods (lookup,like,name) based on the :name field
  #
  acts_as_dictionary :name
  #
  # acts as a tree with parent/children
  #
  acts_as_tree
  # 
  # This record has a full audit log created for changes
  # 
  acts_as_audited :change_log
  # 
  # access control managed via team
  # 
  acts_as_folder_linked
  #
  # team
  #
  belongs_to :team
  # 
  # list of all reports in the project
  # 
  has_many :reports, 
            :class_name=>'Report',
            :foreign_key =>'project_id',
            :order=>'reports.name',
            :dependent => :destroy
  # 
  # list of all cross tabs in the project
  # 
  has_many :cross_tabs, 
            :class_name=>'CrossTab',
            :foreign_key =>'project_id',
            :order=>'cross_tabs.name',
            :dependent => :destroy
  # 
  # List of all the folders in the project
  # 
  has_many :folders, 
            :class_name=>'ProjectFolder',
            :foreign_key =>'project_id',
            :order=>'project_elements.left_limit',
            :dependent => :destroy
  # 
  # List of all the elements
  # 
  has_many :elements,
            :class_name=>'ProjectElement',
            :foreign_key =>'project_id',
            :order=>'project_elements.left_limit',
            :dependent => :destroy
  #
  # List of projects settings normally accessed via ProjectSetting.name = value and
  # controlled via config/project_settings.yml
  #
  has_many :settings,
            :class_name=>'ProjectSetting',
            :foreign_key =>'project_id',
            :dependent => :destroy

  # 
  # The project is the main holder of schedules but in turn can be seen on a
  # system schedule
  # 
  acts_as_scheduled :summary=>:tasks

  has_many_scheduled :assays,  
                      :class_name=>'Assay',
                      :foreign_key =>'project_id',
                      :dependent => :destroy
  
  has_many_scheduled :experiments,
                     :class_name=>'Experiment',
                     :foreign_key =>'project_id',
                     :dependent => :destroy

  has_many_scheduled :tasks, :class_name=>'Task',  
                     :foreign_key =>'project_id',
                     :dependent => :destroy
  # 
  # Scheduled requests
  # 
  has_many_scheduled :requests , :class_name=>'Request', 
                      :foreign_key=> 'project_id',
                      :dependent => :destroy
  # 
  # Schedule of all the services requested from the current project (eg. stuff
  # other want me to do)
  # 
  has_many_scheduled :requested_services ,
    :class_name=>'RequestService',
    :finder_sql => 'SELECT request_services.*,assays.project_id FROM request_services LEFT OUTER JOIN assay_queues ON assay_queues.id = request_services.service_id  LEFT OUTER JOIN assays ON assays.id = assay_queues.assay_id   WHERE assays.project_id =  #{id}',                                 
    :order =>'request_services.started_at desc'                                        
  # 
  # Schedule of all the queued_items in the current project
  # 
  has_many_scheduled :queue_items, 
    :class_name=>'QueueItem',  
    :finder_sql => 'SELECT queue_items.*,assays.project_id FROM queue_items LEFT OUTER JOIN assay_queues ON assay_queues.id = queue_items.assay_queue_id LEFT OUTER JOIN assays ON assays.id = assay_queues.assay_id WHERE assays.project_id =  #{id}',                                 
    :order =>'queue_items.started_at desc'   

  # 
  # A Project as a type to govern is general look and feel This changes the
  # rules for dashboard layout
  # 
  belongs_to :project_type
  #
  # List of assets associated with the the project in reverse order
  # thumbnails etc are children of the root Assets
  # 
  has_many  :assets, 
            :class_name=>'ProjectAsset',
            :order => 'created_at desc',
            :dependent => :destroy ,
            :conditions => 'parent_id is null' do
    def images
      find(:first, :conditions=>["project_id=? and content_type like 'image%'",proxy_owner.id])
    end

    def content(type)
      if type.class==Array
        find(:all, :conditions=>["project_id=? and content_type in ? ",proxy_owner.id,type])
      else
        find(:all,:conditions=>["project_id=? and content_type like ? ",proxy_owner.id,type])
      end
    end
  end
  # 
  ## List of all articles associated with a the project in reverse order
  # 
  has_many  :articles, :class_name=>'ProjectContent', :order => 'created_at desc', :dependent => :destroy 

  def initialize(options = {})
    super(options)  
    Identifier.fill_defaults(self)    
    self.started_at  ||= Time.new
    self.expected_at ||= Time.new + 6.months
  end   

  def validate_title
    (self.project_type and self.project_type.study?)
  end

  def home_folder
     self.project_element
  end
  # ## get the home folder for the project creating it if none exists
  # 
  def home    
    self.project_element
  end

#
# path to name
#
  def path
     if parent == nil
        return name
     else
        return parent.path+"/"+name
     end
  end

  def to_s
    "#{self.class}[#{path}]"
  end

  def state_flow
    if self.project_type and self.project_type.state_flow
      self.project_type.state_flow
    else
      StateFlow.default
    end
  end
  #
  # Hook for custom name generator for the record
  #
  def name_generator
      Identifier.find_by_name("domain_#{self.project_type.dashboard.downcase}") if self.project_type
  end
  # 
  # Summary description of the project
  # 
  def summary
    self.description
  end
  
  def style
    return 'default' unless self.project_type 
    self.project_type.name
  end
  # 
  # Get the current dashboard style to use with this project
  # 
  def partial_template(name)
    return name unless self.project_type 
    self.project_type.partial_template(name)
  end
  # 
  # Get the current dashboard style to use with this project
  # 
  def action_template(name)
    return name unless self.project_type 
    self.project_type.action_template(name)
  end


  # 
  # Is there a runnable assay linked to this project
  # 
  def runnable?
    changeable? &&  process_instances.size>0
  end
  # 
  # See if there is content linked to project as a test that in use
  # 
  def in_use?
    (self.folder.all_children_count>5 || self.assays.size>0 || self.tasks.size>0)
  end
  
  def has_protocols?
    self.protocols.size>0
  end
  # 
  # People in the project
  # 
  def users
    self.team.users.sort{|a,b|a.name<=>b.name}
  end
  #
  # List of teams acsociated with the project
  #
  def teams
    list = self.folder.access_control_list.rules.collect{|i|i.owner if i.owner_type=="Team"}
    [team].concat(list).compact.uniq.sort{|a,b|a.name<=>b.name}
  end
  # 
  #  list of the memberships of the project
  # 
  def memberships
    return [] unless self.team       
    self.team.memberships 
  end
  # 
  # list of the members of the projects
  # 
  def members
    return self.memberships
  end
  # 
  # People to share the ownership of project and so govern the membership
  # 
  def owners
    self.team.owners
  end
  # 
  # List of all the users who are not a member of the project
  # 
  def non_members
    self.team.non_members
  end
  # 
  # Get the member details
  # 
  def member(user)
    self.team.member(user)
  end
  # 
  # Create a shared linked to another object, This create a link to
  # a remove object in set folder based on the model name in the 
  # current projects
  # 
  def share(object)
     root = root_folder_for_class(object)
     root.folder(object)
  end
  #
  # Default foldet to look for items like this in
  #
  def root_folder_for_class(object)
      return self.folder('linked')
  end
  #
  # Add a Link to a another Model
  #  * object a model instance to link to
  #  * return project element of link
  #
  def add_link(object,options={})
    return nil unless Project.current.right?(:data,:share) and Project.current.changeable?
    if (object)
      root = root_folder_for_class(object)
      root.add_link(object,options)
    end 
  end  
  #
  # List of Linked Items
  #  * model class to link to
  #  * return list of linked items of this class
  #
  def linked(clazz)
    if (clazz)
      root = root_folder_for_class(clazz)
      root.linked(clazz)
    end
  rescue Exception => ex
    logger.error "Linked() failed #{ex.message}"
    []
  end 
  #
  # List of Linked Items
  #  * model class to link to
  #  * return boolean true == destoried
  #
  def remove_link(object)
    return nil unless Project.current.right?(:data,:share) and Project.current.changeable?
    if (object)
      root = root_folder_for_class(object)
      item = root.find_within(:first,:conditions=>['reference_type=? and reference_id = ?',object.class.to_s,object.id])
      item.reference=nil
      item.destroy if item
    end 
  end  
  # 
  # get new 'news' content linked to the project
  # 
  def news(count =5 )
    ProjectContent.find(:all,
                        :conditions => ["project_id=? and content_id is not null",self.id] ,
                        :order=>'updated_at desc',
                        :limit => count)
  end 
    
  def children_of_type(count = 5, style = 1)
    Project.list(:all,
                  :conditions => ["parent_id=? and project_type_id = ?",self.id, style],
                  :order=>'updated_at desc',
                  :limit=> count)
  end
  # 
  # Get the latest n record of a type linked to this project. This allows simple
  # discovery of changes to linked records
  # 
  def latest(model = ProjectElement , count=5, field=nil)
    if model.columns.any?{|c|c.name=='project_id'} and model.columns.any?{|c|c.name=='updated_at'}
      model.find(:all,
                  :conditions => ['project_id=?',self.id] ,
                  :order=>'updated_at desc',:limit => count)
      
    elsif field and model.columns.any?{|c|c.name==field.to_s} and model.columns.any?{|c|c.name=='updated_at'}
      model.find(:all,
                  :conditions => ["#{field.to_s}=?",self.id] ,
                  :order=>'updated_at desc',:limit => count)
      
    elsif model.columns.any?{|c|c.name=='updated_at'}
      model.find(:all, :order=>'updated_at desc',:limit => count)
      
    else
      model.find(:all,:order=>'id desc',:limit => count)
      
    end
  end
  # 
  # Get a list of a folders linked to a model
  # 
  def folders_for(model)
    if model.is_a?(Class)
      folder.find_within(:all, :conditions=>["reference_type=?", model.class_name] )
    else
      folder.find_within(:all, :conditions=>["reference_id=? and reference_type=?",
           model.id, model.class.class_name] )
    end  
  end
   # 
  # folders a options list for html forms
  # 
  def folder_options
      self.folders.collect do |folder|
        ["#{'.'*folder.level}#{folder.name}",folder.id]
      end
  rescue 
    []
  end
  # 
  # Helper to return the current active project
  # 
  def Project.current
    @@current || Project.find(Biorails::Record::DEFAULT_PROJECT_ID)
  end
  # 
  # List all requested services provided by this project
  # 
  def outstanding_requested_services(n)
    RequestService.matching(self,{:limit =>n,
        :conditions=>'states.level_no between 0 and 2',
        :order=>'request_services.expected_at'})
  end  
  # 
  # Get a assay for this user, limits to projects the user is a member of
  # 
  def assay(assay_id)
    Assay.find(:first,
      :conditions=>["assays.id =? and #{SQL_ASSAY_EXISTS_CONDITIONS} ",
                    assay_id,
                    self.project_element.project_id,
                    self.project_element.left_limit,
                    self.project_element.right_limit])
  end

  def assay_parameter(assay_parameter_id)
    AssayParameter.find(:first,:include=>[:assay,:parameter_type,:data_element,:role,:data_format],
      :conditions=>["assay_parameters.id =? and #{SQL_ASSAY_EXISTS_CONDITIONS} ",
                    assay_parameter_id,
                    self.project_element.project_id,
                    self.project_element.left_limit,
                    self.project_element.right_limit])
  end

  def assay_queue(assay_queue_id)
    AssayQueue.find(:first,:include=>[:assay],
      :conditions=>["assay_queues.id =? and #{SQL_ASSAY_EXISTS_CONDITIONS} ",
                    assay_queue_id,
                    self.project_element.project_id,
                    self.project_element.left_limit,
                    self.project_element.right_limit])
  end
  # 
  # Get a list of matching protocols linked into the project
  # 
  def protocols
    AssayProtocol.find(:all,:include=>[:assay],
      :order=>'assay_protocols.type desc,assay_protocols.name asc',
      :conditions=>[SQL_ASSAY_EXISTS_CONDITIONS,
                    self.project_element.project_id,
                    self.project_element.left_limit,
                    self.project_element.right_limit])
  end   
#
# Assay linked to the project by definition or reference with this project
#
  def linked_assays
    Assay.list(:all,:conditions=>[SQL_ASSAY_EXISTS_CONDITIONS,
                                  self.project_element.project_id,
                                  self.project_element.left_limit,
                                  self.project_element.right_limit])

  #  list = folder.linked_references(Assay).collect{|i|i.reference_id}
  #  Assay.find(list)
  end  

  def project_list
    list =self.project_element.find_within(:all,
                :conditions=>['type=? and reference_type=?','ProjectFolder','Project'],
                :order=>'project_elements.left_limit')
    [[self.path,self.id]].concat( list.collect{|i|[i.path,i.reference_id]} )
  end
#
# Assays imported from other projects
#
  def imported_assays
    linked_assays - assays
  end
#
# Assays Exported to other projects
#
  def exported_assays
    list = folder.external_references(Assay).collect{|i|i.reference}
    Assay.find(list)
  end
#
# Assay not yet associated with this project
#
  def unlinked_assays
    list = Assay.list(:all) - linked_assays
    list.collect do |i|
      logger.info "#{i.name } [#{i.shareable?(self)}] #{i.shareable_status(self)}"
    end
    list.select{|i|i.shareable?(self)}.sort{|a,b|a.path<=>b.path}
  end  
  
  def usable_assays
    Assay.list( :all,
      :conditions => ["#{SQL_PROTOCOL_VERSION_EXISTS_CONDITIONS} and #{SQL_ASSAY_EXISTS_CONDITIONS}",
                      self.project_element.project_id,
                      self.project_element.left_limit,
                      self.project_element.right_limit])
  end

  # 
  # List of all the valid (released) process instances for this project based on
  # owned and linked assays
  # 
  def process_instances
    ProcessInstance.find(:all,
       :include=>[:protocol=>[:assay]],
       :conditions=>["protocol_versions.status = 'released' and #{SQL_ASSAY_EXISTS_CONDITIONS} ",
                     self.project_element.project_id,
                     self.project_element.left_limit,
                     self.project_element.right_limit])
  end
  # 
  # Get a process instance which is visible and linked to this project
  # 
  def process_instance(process_id)
    ProcessInstance.find(:first,:include=>[:protocol=>[:assay]],
      :conditions=>["protocol_versions.id = ? and #{SQL_ASSAY_EXISTS_CONDITIONS} ",
                     process_id,
                     self.project_element.project_id,
                     self.project_element.left_limit,
                     self.project_element.right_limit])
  end
  # 
  # List of all the valid (released) process flows for this project based on
  # owned and linked assays
  # 
  def process_flows
    ProcessFlow.find(:all,:include=>[:protocol=>:assay],
      :conditions=>["protocol_versions.status = 'released' and #{SQL_ASSAY_EXISTS_CONDITIONS} ",
                     self.project_element.project_id, 
                     self.project_element.left_limit,
                     self.project_element.right_limit])
  end
  # 
  # Get a process Flow which is visible and linked to this project
  # 
  def process_flow(process_id)
    ProcessFlow.find(:first,:include=>[:protocol=>[:assay]],
      :conditions=>["protocol_versions.id = ? and #{SQL_ASSAY_EXISTS_CONDITIONS} ",
        process_id,
        self.project_element.project_id,
        self.project_element.left_limit,
        self.project_element.right_limit])
  end
  # 
  # Get a experiment for this user, limits to projects the user is a member of
  # 
  def experiment(*args)
    experiments.list(*args)
  end
  # 
  # Get a task for this user, limits to projects the user is a member of
  # 
  def task(*args)
    tasks.list(*args)
  end

end
