# == Schema Information
# Schema version: 306
# 
# Table name: projects
# 
#  id                 :integer(11)   not null, primary key
#  name               :string(30)    default(), not null
#  description        :string(1024)  default(), not null
#  status_id          :integer(11)   default(0), not null
#  title              :string(255)
#  email              :string(255)
#  host               :string(255)
#  comment_age        :integer(11)
#  timezone           :string(255)
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  started_at         :datetime
#  ended_at           :datetime
#  expected_at        :datetime
#  done_hours         :float
#  expected_hours     :float
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#  team_id            :integer(11)   default(0), not null
# 

# 
# This is the only web root path and investigation log for project. The Projects
# is build of organizational elements (Assays/Protocols/Services) execution
# elements covering the capture of data (experiments/tasks) and documentation
# build of a number of sections containing articles,assets,comments,reports etc.
# 
# Then the whole system is split into a internal view managed my members of the
# project and a public view seen by subscribers.
# 

class Project < ActiveRecord::Base

  # ## Populated in Application controller with current user for the transaction
  # @todo RJS keep a eye on threading models in post 1.2 Rails to make sure this
  # keeps working
  # 
  cattr_accessor :current

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :status_id 
  # 
  # This record has a full audit log created for changes
  # 
  acts_as_audited :change_log
  # 
  # Add name and description to free text indexing systems
  # 
  acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
    :description=>{:store=>:yes,:boost=>0},
  }, 
    :default_field => [:name],           
    :single_index => true, 
    :store_class_name => true 
  # 
  # access control managed via team
  # 
  access_control_via  :team 
  # 
  # home folders
  # 
  has_one :home_folder, :class_name=>'ProjectFolder', :conditions => 'parent_id is null'
  # 
  # list of all folders in the project
  # 
  has_many :reports, :class_name=>'Report',:foreign_key =>'project_id',:order=>'name', :dependent => :destroy 
  # 
  # List of all the folders in the project
  # 
  has_many :folders, :class_name=>'ProjectFolder',:foreign_key =>'project_id',
    :order=>'left_limit,parent_id,name', :dependent => :destroy 
  # 
  # List of all the elements
  # 
  has_many :elements, :class_name=>'ProjectElement',:foreign_key =>'project_id',
    :order=>'left_limit,parent_id,name', :dependent => :destroy 
 
  # 
  # The project is the main holder of schedules but in turn can be seen on a
  # system schedule
  # 
  acts_as_scheduled :summary=>:tasks

  has_many_scheduled :assays,  :class_name=>'Assay', :order=>'name', 
    :foreign_key =>'project_id', :dependent => :destroy 
  # 
  # List all the assays linked via project folders
  # 
  has_many :unlinked_assays,
    :class_name=>'Assay',    
    :counter_sql=>'select count(id) from assays where not exists (select 1 from project_elements where project_elements.reference_type=' +"'Assay'"+'  and project_elements.reference_id=assays.id  and project_elements.project_id = #{id} )',
    :finder_sql=>'select * from assays where not exists (select 1 from project_elements  where project_elements.reference_type=' +"'Assay'"+'  and project_elements.reference_id=assays.id and project_elements.project_id = #{id} )'
  # 
  # List all the assays not linked to project
  # 
  has_many :linked_assays,
    :class_name=>'Assay',             
    :counter_sql=>'select count(distinct reference_id) from project_elements  where project_elements.reference_type=' +"'Assay'"+'    and project_elements.project_id = #{id} ',            
    :finder_sql=>'select * from assays where exists (select 1 from project_elements  where project_elements.reference_type=' +"'Assay'"+' and project_elements.reference_id=assays.id   and project_elements.project_id = #{id} )'

  
  has_many_scheduled :experiments,  :class_name=>'Experiment',  :foreign_key =>'project_id', :dependent => :destroy 

  has_many_scheduled :tasks,        :class_name=>'Task',  :foreign_key =>'project_id', :dependent => :destroy 
  # 
  # Scheduled requests
  # 
  has_many_scheduled :requests ,    :class_name=>'Request', :foreign_key=> 'project_id'   
                                      
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

  # ## List of assets associated with the the project in reverse order
  # thumbnails etc are children of the root Assets
  # 
  has_many  :assets, :class_name=>'ProjectAsset', :order => 'created_at desc', :dependent => :destroy , :conditions => 'parent_id is null' do
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
  # ## List of all articles associated with a the project in reverse order
  # 
  has_many  :articles, :class_name=>'ProjectContent', :order => 'created_at desc', :dependent => :destroy 
  # 
  # Create a project root folder after create of project
  # 
  after_create do  |project| 
    create_home_folder(project) unless Biorails::Dba.importing?
  end
  
  # 
  # On rename of the project change the folder name
  # 
  def before_update
    ref = self.home
    if ref.name !=self.name
      ref.name = self.name
      ref.save!
    end
  end

  def initialize(options = {})
    super(options)  
    Identifier.fill_defaults(self)    
    self.started_at  ||= Time.new
    self.expected_at ||= Time.new + 6.months
  end   
    
  # ## get the home folder for the project creating it if none exists
  # 
  def home
    return self.home_folder  if self.home_folder
    Project.create_home_folder(self)
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
    process_instances.size>0
  end
  # 
  # See if there is content linked to project as a test that in use
  # 
  def in_use?
    (self.elements.size>1 || self.assays.size>0)
  end
  
  def has_protocols?
    self.protocols.size>0
  end
  # 
  # People in the project
  # 
  def users
    self.team.users
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
  # test wheather is the the owner of the project
  # 
  def owner?(user =nil)
    user ||= User.current
    self.team.owner?(user)     
  end
  # 
  # Create a shared linked to another object
  # 
  def share(object)
    if (object)
      root = self.home.folder(object.class.to_s.underscore.pluralize)
      root.folder(object)
    end 
  end  
  
  # 
  # get new 'news' content linked to the project
  # 
  def news(count =5 )
    ProjectContent.find(:all,:conditions => ["project_id=? and content_id is not null",self.id] , :order=>'updated_at desc',:limit => count)   
  end 
  
  # 
  # Get the latest n record of a type linked to this project. This allows simple
  # discovery of changes to linked records
  # 
  def latest(model = ProjectElement , count=5, field=nil)
    if model.columns.any?{|c|c.name=='project_id'} and model.columns.any?{|c|c.name=='updated_at'}
      model.find(:all,:conditions => ['project_id=?',self.id] ,:order=>'updated_at desc',:limit => count)  
    elsif field and model.columns.any?{|c|c.name==field.to_s} and model.columns.any?{|c|c.name=='updated_at'}
      model.find(:all,:conditions => ["#{field.to_s}=?",self.id] , :order=>'updated_at desc',:limit => count)
    elsif model.columns.any?{|c|c.name=='updated_at'}
      model.find(:all, :order=>'updated_at desc',:limit => count)
    else
      model.find(:all,:order=>'id desc',:limit => count)
    end
  end

  # 
  # Get a root folder my name
  # 
  def folder?(item)
    return self.home.folder?(item)
  end    
  # 
  # Add/find a folder to the project. This  is delegated down to the root folder
  # now
  # 
  def folder(item)
    return home.folder(item)    
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
  # Get a list of a folders linked to a model
  # 
  def folders_for(model)
    if model.is_a?(Class)
      ProjectFolder.find(:all, :conditions=>["project_id= ? and reference_type=?",self.id, model.class_name] )
    else
      ProjectFolder.find(:all, :conditions=>["project_id= ? and reference_id=? and reference_type=?",
          self.id, model.id, model.class.class_name] )
    end  
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
    RequestService.matching(self,{:limit =>n,:conditions=>'request_services.status_id between 0 and 4', :order=>'request_services.expected_at'})
  end  
 
  # 
  # Get a assay for this user, limits to projects the user is a member of
  # 
  def assay(assay_id)
    Assay.find(:first,
      :conditions=>["assays.id =? and exists (select 1 from project_elements 
                         where project_elements.reference_type='Assay' 
                         and project_elements.reference_id=assays.id
                         and project_elements.project_id = ?) ",assay_id,self.id])
  end

  def assay_parameter(assay_parameter_id)
    AssayParameter.find(:first,:include=>[:assay,:parameter_type,:data_element,:role,:data_format],
      :conditions=>["assay_parameters.id =? and exists (select 1 from project_elements 
                         where project_elements.reference_type='Assay' 
                         and project_elements.reference_id=assay_parameters.assay_id
                         and project_elements.project_id = ?) ",assay_parameter_id,self.id])
  end

  def assay_queue(assay_queue_id)
    AssayQueue.find(:first,:include=>[:assay],
      :conditions=>["assay_queues.id =? and exists (select 1 from project_elements 
                         where project_elements.reference_type='Assay' 
                         and project_elements.reference_id=assay_queues.assay_id
                         and project_elements.project_id = ?) ",assay_queue_id,self.id])
  end

  # 
  # Get a list of matching protocols linked into the project
  # 
  def protocols
    @protocols ||= AssayProtocol.find(:all,
      :order=>'assay_protocols.type desc,assay_protocols.name asc',
      :conditions=>["exists (select 1 from project_elements 
                         where project_elements.reference_type='Assay' 
                         and project_elements.reference_id=assay_protocols.assay_id
                         and project_elements.project_id = ? ) ",self.id])
  end
  # 
  # List of all the valid (released) process instances for this project based on
  # owned and linked assays
  # 
  def process_instances
    @process_instances ||= ProcessInstance.find(:all,:include=>[:protocol],
      :conditions=>["exists (select 1 from project_elements 
                         where project_elements.reference_type='Assay' 
                         and project_elements.reference_id=assay_protocols.assay_id
                         and ( protocol_versions.status = 'released')                          
                         and project_elements.project_id = ? ) ",self.id])
  end
  # 
  # Get a process instance which is visible and linked to this project
  # 
  def process_instance(process_id)
    ProcessInstance.find(:first,:include=>[:protocol,:parameters,:contexts],
      :conditions=>["protocol_versions.id = ? and exists (select 1 from project_elements 
                         where project_elements.reference_type='Assay' 
                         and project_elements.reference_id=assay_protocols.assay_id
                         and project_elements.project_id = ? ) ",process_id,self.id])
  end

  # 
  # List of all the valid (released) process flows for this project based on
  # owned and linked assays
  # 
  def process_flows
    @process_flows ||= ProcessFlow.find(:all,:include=>[:protocol],
      :conditions=>["exists (select 1 from project_elements 
                         where project_elements.reference_type='Assay' 
                         and project_elements.reference_id=assay_protocols.assay_id
                         and project_elements.project_id = ?
                         and ( protocol_versions.status = 'released') ) ",self.id])
  end
  # 
  # Get a process Flow which is visible and linked to this project
  # 
  def process_flow(process_id)
    ProcessFlow.find(:first,:include=>[:protocol,:steps],
      :conditions=>["protocol_versions.id = ? and exists (select 1 from project_elements 
                         where project_elements.reference_type='Assay' 
                         and project_elements.reference_id=assay_protocols.assay_id
                         and project_elements.project_id = ? ) ",process_id,self.id])
  end


  # 
  # Get a experiment for this user, limits to projects the user is a member of
  # 
  def experiment(*args)
    experiments.find_visible(*args)
  end
  # 
  # Get a task for this user, limits to projects the user is a member of
  # 
  def task(*args)
    tasks.find_visible(*args)
  end
  
  protected 

  def Project.create_home_folder(project)
    home_folder = ProjectFolder.new(:team_id=>project.team_id,:project_id=>project.id)
    home_folder.reference = project
    home_folder.name = project.name
    home_folder.save
    home_folder
  end
  
end
