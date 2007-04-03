require 'digest/sha1'

##
# User record
# 
# The user is a member of a number of projects. In a project the membership governs by a role 
class User < ActiveRecord::Base


  attr_accessor :password
  attr_accessor :confirm_password
##
# Business Rules for a user
# 
  validates_presence_of :name
  validates_length_of   :name,    :within => 3..40
  validates_format_of   :name, :with => /^[a-z0-9_\-@\.]+$/i
  validates_format_of   :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_uniqueness_of :name, :email, :case_sensitve => false
  validates_length_of   :password, :in => 4..12, :allow_nil => true
  validates_confirmation_of :password, :allow_nil => true

  before_save :encrypt_password
##
# User May have be validated by a number of Authentication systems (LDAP,Password, Open-Id etc)
# 
  belongs_to :authentication, :class_name =>'AuthenticationSystem', :foreign_key => 'authentication_id'
##
# Users have a default role
#   
  belongs_to :role, :class_name=>'Role',:foreign_key=>'role_id'
##
# Users are linked into the system as a the owner of a number of record types
# 
  has_many :tasks
  has_many :requests
  has_many :articles
  has_many :files  
##
# User a linked into projects
#   
  has_many   :projects, :through=>:membership,:order => 'name' 
  has_many   :members, :class_name => 'Membership', :include => [ :project, :role ], :dependent => :delete_all

#  acts_as_paranoid
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
 
##
# get the role for the user in a role
#  
  def members_role(project)
    members.detect{|member|member.project==project} 
  end	
 
##
# Test in the user is authorized for a subject and action in a project
#  	
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


