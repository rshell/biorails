# == Schema Information
# Schema version: 306
#
# Table name: users
#
#  id                 :integer(11)   not null, primary key
#  name               :string(255)   default(), not null
#  password_hash      :string(40)    
#  role_id            :integer(11)   not null
#  password_salt      :string(255)   
#  fullname           :string(255)   
#  email              :string(255)   
#  login              :string(40)    
#  activation_code    :string(40)    
#  state_id           :integer(11)   
#  activated_at       :datetime      
#  token              :string(255)   
#  token_expires_at   :datetime      
#  filter             :string(255)   
#  admin              :boolean(1)    
#  created_at         :datetime      
#  updated_at         :datetime      
#  deleted_at         :datetime      
#  created_by_user_id :integer(11)   default(1), not null
#  updated_by_user_id :integer(11)   default(1), not null
#  is_disabled        :boolean(1)    
#  private_key        :binary        
#

##
# User record
# 
# The user is a member of a number of projects. In a project the membership governs by a role 
class User < ActiveRecord::Base

   class AccessDenied < RuntimeError
      
    end
    
    class NotAuthorized < RuntimeError
      
    end

    class NotAuthenticated < RuntimeError
      
    end
##
# Populated in Application controller with current user for the transaction
# @todo RJS keep a eye on threading models in post 1.2 Rails to make sure this keeps working 
#
  cattr_accessor :current
##
# Do user authorization and authentication has been moded to a plugin
# 
# In implementation alces_access_control plugin to customize authorization and
# authenication functions. To allow delegation to LDAP, OS etc.
# 
  access_authenticated  :username => :login, 
                        :passsword => :password_hash
                           
  access_control_role :role                      
##
# Business Rules for a user
# 
  attr_accessor :password
  attr_accessor :password_confirmation
# validates_confirmation_of :password

  validates_presence_of   :name
  validates_presence_of   :role 
  validates_length_of     :login, :within => 3..40
  validates_format_of     :login, :with => /^[a-z0-9_\-@\.]+$/i
  validates_uniqueness_of :login, :case_sensitve => false

#  validates_presence_of   :password_hash
#  validates_length_of     :password, :in => 4..12, :allow_nil => true

# validates_format_of   :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

##
# User a linked into projects
#   
  has_many   :teams, :through=>:memberships, :order => 'name' 
##
# Has membership of a a number of projects with a set role in each
#   
  has_many   :memberships, :include => [ :team, :role ], :dependent => :delete_all
##
# Users are linked into the system as a the owner of a number of record types
# 
  has_many :requests ,   :class_name=>'Request',      :foreign_key=> 'requested_by_user_id'
  has_many :assays ,    :class_name=>'Assay',        :foreign_key=> 'created_by_user_id'
  has_many :protocols ,  :class_name=>'AssayProtocol',:foreign_key=> 'created_by_user_id'

  has_many_scheduled :requested_services ,:class_name=>'RequestService', :foreign_key=> 'requested_by_user_id'  
  has_many_scheduled :experiments ,:class_name=>'Experiment',   :foreign_key=> 'created_by_user_id'  
  has_many_scheduled :tasks ,      :class_name=>'Task',         :foreign_key=> 'assigned_to_user_id'   
  has_many_scheduled :queue_items, :class_name=>'QueueItem',    :foreign_key=> 'assigned_to_user_id'
##
# unstructured data
# 
  has_many :articles, :class_name=>'ProjectContent', :foreign_key=> 'created_by_user_id'
  has_many :files,    :class_name=>'ProjectAsset',   :foreign_key=> 'created_by_user_id'  
##
# Has a record of all the changes they have performed
  has_many :audits  
##
# Users can sign and witness documents - so they can both create a signature object, and sign it
  has_many :created_signatures, :class_name=>"Signature", :foreign_key=>"created_by_user_id"
  has_many :signed_signatures, :class_name=>"Signature", :foreign_key=>"user_id"
  
  #class method - we will not have a user object if the login failed
  def self.register_login_failure(username)
       user =  User.find(:first,:conditions => ['login=?',username])
       return false unless user
     unless user.login_failures < SystemSetting.max_login_attempts
       Notification.deliver_excessive_login_failures(user)
    end
    user.update_attribute(:login_failures, user.login_failures+1)
   end
   
  #give all users a cryptographic key
  def before_create 
    generate_key
  end
  
 def fill_from_ldap
   ldap = User.ldap_user(login)
   if ldap
     self.name = ldap.cn.to_s
     self.email = ldap[:mail].to_s
     self.fullname == ldap.displayName.to_s || ldap.cn.to_s
   end
 rescue Exception=>ex
   logger.warn("Failed to find all attributes in LDAP #{ex.message}")   
 end  
 
 def self.create_user(username,password=nil,role_id=1)
   user = User.new
   user.role_id = Biorails::Record::DEFAULT_USER_ROLE
   user.login = username
   user.name = username
   user.fill_from_ldap
   if user.save
     user.memberships.create(:team_id=> Biorails::Record::DEFAULT_TEAM_ID, :role_id=> role_id)
     user.reload
   end
   user
 end    
##
# This record has a full audit log created for changes 
#   
#  acts_as_audited :change_log
  
#  acts_as_paranoid
##
# Class level methods
# 
  # Returns the user that matches provided login and password, or nil
  def self.login(username, password)
    user = User.authenticate(username, password)
    if user
       logger.info "#{username} is a known username"
       return user
    else
       logger.info "#{username} is a not known"
       return nil
    end
  end

##
# Create a new Project owned by this user
#  accepts a list of parameters for the project eg {:name=>'xxxx',:summary=>'ddddd'}
#  the user is automatically made a member of the project and its owner
# 
# 
  def create_project(params={})
     Project.transaction do 
       project = Project.new(params)
       project.description||= "New Project #{params[:name]} created by user #{self.name}"
       project.team_id ||= Team.current.id
       project.save     
       return project
     end
  end
##
# Create a new Team owned by this user
#  accepts a list of parameters for the project eg {:name=>'xxxx',:summary=>'ddddd'}
#  the user is automatically made a member of the project and its owner
# 
# 
  def create_team(params={})
     Team.transaction do 
       team = Team.new(params)
       team.description ||= "New Team #{params[:name]} created by user #{self.name}"
       team.save    
       self.memberships.create(:team_id => team.id,:role_id=>ProjectRole.owner.id,:owner=> true)       
       return team
     end
  end

##
# reset the password for the user
   def reset_password( old_value, new_value )
      if password?(old_value)
        self.set_password(new_value)
        return true
      else
        return false        
      end
   end  
   
   def clear_login_failures
     update_attribute(:login_failures, 0)
   end
  
  def news(count =5 )
    ProjectElement.find(:all,:conditions => ['content_id is not null and updated_by_user_id=?',self.id] , :order=>'updated_at desc',:limit => count)   
  end
  #
  # Projects the user can see via admin or membership rights
  #
  def projects(limit=10) 
    return Project.find(:all) if self.admin?
    Project.find(:all,
                 :limit => limit,
                 :order => 'projects.updated_at desc',
                 :include=>[:team => [:memberships]],:conditions=>['memberships.user_id=?',self.id]) 
  end  
  ##   
  #
  # Get a project for the current user
  #
  def project(id)
    return Project.find_by_id(id) if self.admin?
    Project.find(:first,:include=>[:team => [:memberships]],:conditions=>['projects.id =? and memberships.user_id=?',id,self.id]) 
  end
  
  #
  # Get a element for this user, limits to projects the user is a member of
  #  
  def element(*args)
     ProjectElement.find_visible(*args)
  end
  #
  # Get a folder for this user, limits to projects the user is a member of
  #  
  def folder(*args)
     ProjectFolder.find(*args)
  end
  #
  # Get a assay for this user, limits to projects the user is a member of
  #  
  def assay(*args)
     Assay.find_visible(*args)
  end
  #
  # Get a assay for this user, limits to projects the user is a member of
  #  
  def protocol(key)
    cond = <<SQL
    exists (select 1 from memberships m where m.user_id=#{self.id} and m.team_id=assays.team_id)
    or assay_protocols.created_by_user_id =#{self.id}
SQL
      AssayProtocol.find(key,:include=>[:assay],:conditions => cond )
   rescue Exception => ex
     logger.info "Failed to find object "+ex.message
     return nil
  end

  def process_flow(key)
    cond = <<SQL
    exists (select 1 from memberships m where m.user_id=#{self.id} and m.team_id=assays.team_id)
    or protocol_versions.created_by_user_id =#{self.id}
SQL
      ProcessFlow.find(key,:include=>[:protocol=>[:assay]],:conditions => cond )
   rescue Exception => ex
     logger.info "Failed to find object "+ex.message
     return nil
  end
  
  def process_instance(key)
    cond = <<SQL
    exists (select 1 from memberships m where m.user_id=#{self.id} and m.team_id=assays.team_id)
    or protocol_versions.created_by_user_id =#{self.id}
SQL
      ProcessInstance.find(key,:include=>[:protocol=>[:assay]],:conditions => cond )
   rescue Exception => ex
     logger.info "Failed to find object "+ex.message
     return nil
  end
  
  #
  # Get a linked request
  #
  def requested_service(key)
    cond = <<SQL
    exists (select 1 from memberships m where m.user_id=#{self.id} and m.team_id=requests.team_id)
    or requested_services.created_by_user_id =#{self.id}
SQL
      RequestService.find(key,:include=>[:request,:queue],:conditions => cond )
   rescue Exception => ex
     logger.info "Failed to find object "+ex.message
     return nil
  end
  #
  # Get a linked request
  #
  def assay_queue(key)
    cond = <<SQL
     exists (select 1 from memberships m where m.user_id=#{self.id} and m.team_id=assays.team_id)
     or assay_queues.created_by_user_id =#{self.id}
SQL
      AssayQueue.find(key,:include=>[:assay],:conditions => cond )
   rescue Exception => ex
     logger.info "Failed to find object "+ex.message
     return nil
  end
  #
  # Get a linked request
  #
  def request(*args)
    Request.find_visible(*args)
  end
  #
  # Get a experiment for this user, limits to projects the user is a member of
  #  
  def experiment(*args)
     Experiment.find_visible(*args)
  end
  #
  # Get a task for this user, limits to projects the user is a member of
  #
  def task(*args)
    Task.find_visible(*args)
  end
###
# Get the latest n record of a type linked to this user   
# 
  def latest(model = Task, count=5, field=nil)
    if field and model.columns.any?{|c|c.name==field.to_s} and model.columns.any?{|c|c.name=='updated_at'}
       model.find(:all,:conditions => ["#{field.to_s}=?",self.id] , :order=>'updated_at desc',:limit => count)
       
    elsif model.columns.any?{|c|c.name=='assigned_to_user_id'} and model.columns.any?{|c|c.name=='updated_at'}
       model.find(:all,:conditions => ['assigned_to_user_id=?',self.id] , :order=>'updated_at desc',:limit => count)
       
    elsif model.columns.any?{|c|c.name=='requested_by_user_id'} and model.columns.any?{|c|c.name=='updated_at'}
       model.find(:all,:conditions => ['requested_by_user_id=?',self.id] ,:order=>'updated_at desc',:limit => count)
       
    elsif model.columns.any?{|c|c.name=='updated_by_user_id'} and model.columns.any?{|c|c.name=='updated_at'}
       model.find(:all,:conditions => ['updated_by_user_id=?',self.id], :order=>'updated_at desc',:limit => count)
       
    elsif model.columns.any?{|c|c.name=='created_by_user_id'} and model.columns.any?{|c|c.name=='updated_at'}
       model.find(:all,:conditions => ['created_by_user_id=?',self.id] ,  :order=>'updated_at desc',:limit => count)
       
    else
      model.find(:all,:order=>'id desc',:limit => count)
    end
  end
 
 def disabled?
   !enabled?
 end

 def enabled?
    self.deleted_at.nil?
 end

 def admin?
    self.admin
end  

def style
  if self.disabled?
      "Disabled"
   elsif self.admin? 
     "Administrator"
   else
     "Normal"
   end
end
##
# get the role for the user in a role
#  
  def membership(project)
    Membership.find(:first,:conditions=>['team_id=? and user_id=?',project.team.id,self.id],:include=>:role)
  end	
  	  
#
# Get the cached current user for this context
# 
  def User.current
    @@current ||= User.find(Biorails::Record::DEFAULT_GUEST_USER_ID)
  end

  def User.selector
     User.find(:all).collect{|item|[item.name,item.id]}
  end
    
  def has_published_documents?
    return Signature.find(:first,
              :include=>[:project_element=>[:team => [:memberships]]],
              :order=>'project_elements.updated_at desc',
              :conditions=>{'project_elements.created_by_user_id'=>self.id,
                            'memberships.user_id'=>self.id,
                            'signatures.signature_role'=>'AUTHOR'})

  end      
  
  def to_xml(options = {})
         my_options = options.dup
         my_options[:except] = [:private_key,:public_key,:token,:activation_code,:password_salt,:password_hash]
         my_options[:include] = [:teams, :projects]
        Alces::XmlSerializer.new(self, my_options ).to_s
  end
  #
  # Get the project key
  #
  def public_key
    return @public_key if @public_key
    @public_key = private_key.public_key
  rescue 
    logger.error "Failed to get public key for user #{self.id}"    
  end
  #
  # generate a key pair
  #
  def generate_key
    self.private_key= OpenSSL::PKey::RSA.generate(4096).to_s
  rescue 
    logger.error "Failed to generate private key for user #{self.id} has gem install crypt ? been done "        
  end
  #
  # get the private key generating on fly if needed
  #
  def private_key
     return @private_key if  @private_key
     unless self.attributes["private_key"]
       logger.warn "No key generating on the fly"
       self.generate_key
       self.save!
     end
     @private_key =  OpenSSL::PKey::RSA.new(self.attributes["private_key"])
  rescue 
    logger.error "Failed to get public key for user #{self.id}"    
  end
  
  def to_s
    return name
  end

end


