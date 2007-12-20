#
# Teams are used to manage access to data in the system. 
# A team has a set membership with each member having a set role which govens 
# the access they have to the record. On top of this a user may be seen as 
# a owner of the team which allows them to change the who in the team and 
# there rights. There can be more then one owner to cover to multiple sites
# holidays etc.
# 
# Teams own projects,studies,experiments,requests etc.
# 
# When doing CRUD of a object the following are checked
# 
#  1) user.is_admin? Users has full system liability so can do anythin
#  2) !object.public?
#  3) user.permission('update',
#  
# 
#
#
#
class Team < ActiveRecord::Base

##
# Populated in Application controller with current user for the transaction
#
  cattr_accessor :current
#
# Maked sure teams are named objects with a description for use in tooltips etc
#
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
# Link through to users for members, and owners via memberships
# 
  access_control_list  :memberships , :dependent => :destroy 

  has_many :users, :through => :memberships, :source => :user
#
# People to share the ownership of project and so govern the membership
#
  has_many :owners,  :through => :memberships, :source => :user, :conditions => ['memberships.is_owner = ? or users.admin = ?', true, true]
#
# List of all the elements 
#
  has_many :projects, :class_name=>'Project',:foreign_key =>'team_id',:order=>'name', :dependent => :destroy 

#
# List of all the users who are not a member of the project
# 
  def non_members
    User.find(:all,:conditions=>[" not exists (select 1 from memberships where memberships.team_id=? and memberships.user_id=users.id)",self.id] )    
  end
  
  def in_use?
    (self.projects.size>0)
  end
#
# Get the member details
#  
  def member(user)
    Membership.find(:first,:conditions=>['team_id=? and user_id=?',self.id,user.id],:include=>:role)
  end
#
# test wheather is the the owner of the project
#
  def owner?(user)
    member_details = Membership.find(:first,:conditions=>['team_id=? and user_id=?',self.id,user.id],:include=>:role)
    return (member_details and member_details.is_owner)
  end

#
# Helper to return the current active project 
# 
  def Team.current
    @@current ||= Project.current.team
  end

#
# get new 'news' content linked to the project
#
  def news(count =5 )
    ProjectContent.find(:all,:conditions => ["team_id=? and content_id is not null",self.id] , :order=>'updated_at desc',:limit => count)   
  end  
  
end
