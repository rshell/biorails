# == Schema Information
# Schema version: 233
#
# Table name: users
#
#  id               :integer(11)   not null, primary key
#  name             :string(255)   default(), not null
#  password_hash    :string(40)    
#  password_salt    :string(255)   
#  role_id          :integer(11)   
#  fullname         :string(255)   
#  email            :string(255)   
#  activation_code  :string(40)    
#  state_id         :integer(11)   
#  activated_at     :datetime      
#  token            :string(255)   
#  token_expires_at :datetime      
#  filter           :string(255)   
#  admin            :boolean(1)    
#  created_at       :datetime      
#  updated_at       :datetime      
#  deleted_at       :datetime      
#

require 'digest/sha1'

##
# User record
# 
# The user is a member of a number of projects. In a project the membership governs by a role 
class User < ActiveRecord::Base
##
# Do user authorization and authentication has been moded to a plugin
# 
# In implementation alces_access_control plugin to customize authorization and
# authenication functions. To allow delegation to LDAP, OS etc.
# 
  access_authenticated  :username => :login, 
                        :passsword => :password_hash
                           
  access_control_via   :role                      

##
# Business Rules for a user
# 
  validates_presence_of   :name
  validates_length_of     :name,    :within => 3..40
  validates_format_of     :name, :with => /^[a-z0-9_\-@\.]+$/i
  validates_uniqueness_of :name, :case_sensitve => false
  
#  validates_length_of     :password, :in => 4..12, :allow_nil => true

# validates_format_of   :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

##
# Users are linked into the system as a the owner of a number of record types
# 
  has_many :tasks ,   :class_name=>'Task',           :foreign_key=> 'assigned_to'
  has_many :requests ,:class_name=>'Request',        :foreign_key=> 'requested_by'
  has_many :articles, :class_name=>'ProjectContent', :foreign_key=> 'created_by'
  has_many :files,    :class_name=>'ProjectAsset',   :foreign_key=> 'created_by'  
##
# User a linked into projects
#   
  has_many   :projects, :through=>:memberships, :order => 'name' 
  has_many   :memberships, :include => [ :project, :role ], :dependent => :delete_all

#  acts_as_paranoid
##
# Class level methods
# 
  # Returns the user that matches provided login and password, or nil
  def self.login(username, password)
    user = User.authorized(username, password)
    if user
       logger.info "#{username} is a known username"
    else
       logger.info "#{username} is a not known"
    end
  end

##
# Create a new Project owned by this user
# 
  def create_project(name)
     Project.transaction do 
       project = Project.new(:name=>name)
       project.summary = "New Project #{name} created by user #{self.name}"
       project.save     
       project.owner = self
       return project
     end
  end

##
# reset the password for the user
   def reset_password( old_value, new_value )
      if authenticated?(old_value)
        self.set_password(new_value)
      end
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
  def membership(project)
    Membership.find(:first,:conditions=>['project_id=? and user_id=?',self.id,user.id],:include=>:role)
  end	
 
##
# Test in the user is authorized for a subject and action in a project
#  	
  def authorized?(subject,action)
    membership = membership(project)
    if membership.nil?
       return self.admin  # Your not a member
    else
       return membership.allow?(subject,action)
    end
  end 	

end


