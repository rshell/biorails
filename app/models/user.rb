# == Schema Information
# Schema version: 359
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)     default(""), not null
#  password_hash      :string(40)
#  role_id            :integer(4)      not null
#  password_salt      :string(255)
#  fullname           :string(255)
#  email              :string(255)
#  login              :string(40)
#  activation_code    :string(40)
#  state_id           :integer(4)
#  activated_at       :datetime
#  token              :string(255)
#  token_expires_at   :datetime
#  filter             :string(255)
#  admin              :boolean(1)
#  is_disabled        :boolean(1)
#  private_key        :binary
#  login_failures     :integer(4)      default(0), not null
#  created_at         :datetime
#  updated_at         :datetime
#  deleted_at         :datetime
#  created_by_user_id :integer(4)      default(1), not null
#  updated_by_user_id :integer(4)      default(1), not null
#

# == Description
# User record
# 
# The user is a member of a number of projects. In a project the membership governs by a role 
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

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
  access_authenticated  :username => :login, :passsword => :password_hash
                           
  belongs_to :role
  ##
  # Business Rules for a user
  # 
  attr_accessor :password
  attr_accessor :old_password
  attr_accessor :password_confirmation

  validates_confirmation_of :password  
  validates_length_of  :password,  :minimum=>3 ,:allow_nil=>true    

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
  has_many   :memberships, :include => [ :team], :dependent => :delete_all
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
  
  end  
 
  def self.create_user(username,password=nil,role_id=nil)
    user = User.new
    user.role_id = role_id || Biorails::Record::DEFAULT_USER_ROLE
    user.login = username
    user.name = username
    user.password = password
    user.fill_from_ldap
    if user.save
      user.memberships.create(:team_id=> Biorails::Record::DEFAULT_TEAM_ID)
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
      return team unless team.save 
      self.memberships.create(:team_id => team.id,:owner=> true)       
      return team.reload
    end
  end

  ##
  # reset the password for the user
  def reset_password( old_value, new_value,confirm_value )
    if password?(old_value)
      self.password_confirmation = new_value
      self.password = new_value
      self.password_confirmation = confirm_value
      self.set_password(self.password)
      return self.save 
    else
      self.errors.add(:old_password,'value is not valid')
      return false        
    end
  end  
   
  def clear_login_failures
    update_attribute(:login_failures, 0)
  end
  #
  # List of all the users who are not a member of the project
  #
  def other_teams
    @non_members ||=Team.find(:all,:conditions=>[" not exists (select 1 from memberships where memberships.team_id=teams.id and memberships.user_id=?)",self.id] )
  end
  
  def news(count =5 )
    ProjectElement.find(:all,:conditions => ['content_id is not null and updated_by_user_id=?',self.id] , :order=>'updated_at desc',:limit => count)   
  end
  #
  # Projects the user can see via admin or membership rights
  #
  def projects(limit=5) 
    if self.admin?
      Project.list(:all,
      :limit => limit,
      :order => 'projects.updated_at desc') 
     else
      Project.list(:all,
      :limit => limit,
      :order => 'projects.updated_at desc')   
    end
  end

  def project_list
    [["<none>",nil]].concat( Project.list(:all,:order=>'projects.name,projects.parent_id').collect{|i|
        [ "#{i.name}" + (i.parent ? " [#{i.parent.path}]" : ''),i.id]})
  end
  ##   
  #
  # Get a project for the current user
  #
  def project(id)
    return Project.find(id) if self.admin?
    Project.load(id) 
  end
  
  ###
  # Get the latest n record of a type linked to this user   
  # 
  def latest(model = Task, count=5, starting_with=nil)
    items = []
    items << ["#{model.table_name}.name  like ? ","#{starting_with}%"] if starting_with and model.columns.any?{|c|c.name =='name'}
    items << ["#{model.table_name}.updated_by_user_id  = ?",self.id] if model.columns.any?{|c|c.name =='updated_by_user_id'}
    items << ["#{model.table_name}.created_by_user_id  = ?",self.id] if model.columns.any?{|c|c.name =='created_by_user_id'}
    items << ["#{model.table_name}.assigned_to_user_id = ?",self.id] if model.columns.any?{|c|c.name =='assigned_to_user_id'}
    items << ["#{model.table_name}.created_by_user_id  = ?",self.id] if model.columns.any?{|c|c.name =='requested_by_user_id'}
    conditions = []
    values = []
    return [] unless items and items.size>0
    for item in items
      conditions <<  item[0]
      values << item[1]
    end
    if model.respond_to?(:list)
       model.list(:all, :conditions=> [conditions.join(" or "),values].flatten,:order=>"#{model.table_name}.id desc",:limit => count ) 
    else
       model.find(:all, :conditions=> [conditions.join(" or "),values].flatten,:order=>"#{model.table_name}.id desc",:limit => count ) 
    end
  rescue Exception => ex
    logger.info "Failed to find object: #{ex.message}"
    return []
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
  #
  # Standard permission? check on access control list
  #   
  def right?(subject,action=nil)
    admin? or role.right?(subject,action)
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
      :include=>[:project_element=>[:state]],
      :order=>'project_elements.updated_at desc',
      :conditions=>{'project_elements.created_by_user_id'=>self.id,
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
    return "user [#{login}]"
  end

end


