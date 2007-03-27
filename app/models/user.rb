require 'digest/sha1'

class User < ActiveRecord::Base
  @@admin_scope = {:find => { :conditions => ['admin = ?', true] } }

  @@membership_options = {
     :select => 'distinct users.*, memberships.admin as project_admin',
     :order => 'users.name',
     :joins => 'left outer join memberships on users.id = memberships.user_id'}
    
  # Account status
  STATUS_NEW      = 0
  STATUS_VALID    = 1
  STATUS_EXPIRED  = -1 


  belongs_to :authentication, :class_name =>'AuthenticationSystem', :foreign_key => 'authentication_id'
  belongs_to :role, :class_name=>'Role'

  has_many   :projects, :through=>:memberships,:order => 'name' 
  has_many   :memberships, :class_name => 'Membership', :include => [ :project, :role ], :dependent => :delete_all

  attr_accessor :password
  attr_accessor :confirm_password

  validates_presence_of :name
  validates_length_of   :name,    :within => 3..40
  validates_format_of   :name, :with => /^[a-z0-9_\-@\.]+$/i
  validates_format_of   :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_uniqueness_of :name, :email, :case_sensitve => false
  validates_length_of   :password, :in => 4..12, :allow_nil => true
  validates_confirmation_of :password, :allow_nil => true

  before_save :encrypt_password

  has_many :articles
  acts_as_paranoid

  has_many :tasks
  has_many :requests

##
# Class level methods
# 
  # Returns the user that matches provided login and password, or nil
  def self.login(username, password)
    user = find(:first, :conditions => ["name=?", username])
    if user
       logger.info "#{username} is a known username"
       user.password = password
       return user if user and  user.valid?
    else
       logger.info "#{username} is a new username"
       user = User.new(:name=> username)
       user.login = username
       user.set_password(password)
       user.save
       return user
    end
  end
	
  def self.find_admins(*args)
    with_scope(@@admin_scope) { find *args }
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate_for(project, name, password)
    user = find(:first, @@membership_options.merge(
      :conditions => ['users.name = ? and (memberships.project_id = ? or users.admin = ?)', name, project.id, true]))
    user && user.authenticated?(password) ? user : nil
  end

  def self.find_by_project(project, id)
    with_deleted_scope { find_by_project_with_deleted(proejct, id) }
  end

  def self.find_by_project_with_deleted(project, id)
    find_with_deleted(:first, @@membership_options.merge(
      :conditions => ['users.id = ? and (memberships.project_id = ? or users.admin = ?)', id, project.id, true]))
  end

  def self.find_all_by_project(project, options = {})
    with_deleted_scope { find_all_by_project_with_deleted(project, options) }
  end

  def self.find_all_by_project_with_deleted(project, options = {})login
    find_with_deleted(:all, @@membership_options.merge(options.reverse_merge(:conditions => ['memberships.project_id = ? or users.admin = ?', project.id, true]))).uniq
  end

  def self.find_by_token(project, token)
    find(:first, @@membership_options.merge(:conditions => ['token = ? and token_expires_at > ? and (memberships.project_id = ? or users.admin = ?)', token, Time.now.utc, project.id, true]))
  end

###
# Find a   
  def self.find_by_email(project, email)
    find(:first, @@membership_options.merge(
    :conditions => ['email = ? and (memberships.project_id = ? or users :controller => /routing_navigator|account|(admin\/\w+)/.admin = ?)', email, project.id, true]))
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

##
# reset the username for this user
#  
   def username=(new_user)
     if (new_user!=self.name)
        self.name = new_user
        self.password_salt = self.username + rand.to_s
        self.password_hash = Digest::SHA1.hexdigest(self.password_salt.to_s +  self.password.to_s).to_s
    end     
   end
##
# get the username   
#
   def username
     self.name
   end

##
#
   def set_password(value)
      self.password = value.to_s
      self.password_salt = self.name.to_s + rand.to_s
      self.password_hash = Digest::SHA1.hexdigest(self.password_salt + self.password.to_s).to_s
   end

   def test_password(value)
      return self.password_hash == Digest::SHA1.hexdigest(self.password_salt.to_s + value.to_s).to_s
   end
   
###
# Get the lastest n record of a type linked to this user   
# 
  def lastest(model = Task, count=5)
    if model.columns.any?{|c|c.name=='user_id'} and model.columns.any?{|c|c.name=='updated_at'}
    
       model.find(:all,:conditions => ['user_id=?',self.id] ,
                  :order=>'updated_at desc',:limit => count)
       
    elsif model.columns.any?{|c|c.name=='updated_by'} and model.columns.any?{|c|c.name=='updated_at'}
    
       model.find(:all,:conditions => ['updated_by=?',self.id],
                  :order=>'updated_at desc',:limit => count)
       
    else
      model.find(:all,:order=>'id desc',:limit => count)
    end
  end
 
  def members_role(project)
    memberships.detect{|member|member.project==project} 
  end	
 	
  def authorized(project,subject,action)
      if project.owner_id == self.id
      return true # Your project so free to do anything
    end
    membership = User.member_role(project)
    if membership.nil?
      return false # Not a member
    end    
    membership.allows?(subject,action) # what you allowed to do
  end 	


##
# Test the account is authenticated. This will use a defined authentication system. no drop through to
# simple password hash it none is defined
   def valid?
     if authentication 
       return authentication.validate(user)
     else
       return test_password(self.password)
     end
   end
   

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, password_salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def token?
    token_expires_at && Time.now.utc < token_expires_at 
  end

  # The project admin property is brought in from memberships.admin, when joined with the project table.
  def project_admin?
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean read_attribute(:project_admin)
  end

  def reset_token!
    returning self.token = rand_key do |t|
      self.token_expires_at = 2.weeks.from_now.utc
      save!
    end
  end

  def to_liquid
    UserDrop.new self
  end

  protected

    def encrypt_password
      return if password.blank?
      self.password_salt = rand_key if new_record?
      self.password_hash = encrypt(password)
    end
    
    def password_required?
      crypted_password.nil? || !password.blank?
    end
    
    def rand_key
      Digest::SHA1.hexdigest("--#{Time.now.to_s.split(//).sort_by {rand}.join}--#{name}--")
    end
	

end


