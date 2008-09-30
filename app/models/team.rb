# == Schema Information
# Schema version: 359
#
# Table name: teams
#
#  id                 :integer(4)      not null, primary key
#  name               :string(30)      default(""), not null
#  description        :string(2048)    default(""), not null
#  status_id          :integer(4)      default(0), not null
#  public_role_id     :integer(4)      default(1), not null
#  external_role_id   :integer(4)      default(1)
#  email              :string(255)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  created_by_user_id :integer(4)      default(1), not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#

# == Description
#
# Teams are used to manage access to data in the system. 
# 
# A team has a set membership with each member having a set role which govens 
# the access they have to the record. On top of this a user may be seen as 
# a owner of the team which allows them to change the who in the team and 
# there rights. There can be more then one owner to cover to multiple sites
# holidays etc.
# 
# Teams own projects,assays,experiments,requests etc.
# 
# When doing CRUD of a object the following are checked
# 
#  1) user.is_admin? Users has full system liability so can do anythin
#  2) !object.public?
#  3) user.permission('update',
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
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
  # Default Access control list for team
  #
  has_one :access_control_list  
  
  after_create :create_default_team_access_control_list
  #
  # Link through to users for members, and owners via memberships
  # 
  has_many :memberships , :dependent => :destroy 

  has_many :users, :through => :memberships, :source => :user
  #
  # People to share the ownership of project and so govern the membership
  #
  has_many :owners,  :through => :memberships, :source => :user, :conditions => ['memberships.is_owner = ? or users.admin = ?', true, true]
  #
  # List of all the projects
  #
  has_many :projects, :class_name=>'Project',:foreign_key =>'team_id',:order=>'name', :dependent => :destroy 
  #
  # List of all the assays
  #
  has_many :assays, :class_name=>'Assay',:foreign_key =>'team_id',:order=>'name', :dependent => :destroy 
  #
  # List of all the experiments
  #
  has_many :experiments, :class_name=>'Experiment',:foreign_key =>'team_id',:order=>'name', :dependent => :destroy 

  #
  # List of all the users who are not a member of the project
  # 
  def non_members
    @non_members ||=User.find(:all,:conditions=>[" not exists (select 1 from memberships where memberships.team_id=? and memberships.user_id=users.id)",self.id] )    
  end
  
  def in_use?
    (self.projects.size>0)
  end
  #
  # Get the member details
  #  
  def member(user)
    memberships.find(:first,:conditions=>['user_id=?',user.id])
  end
  #
  # test wheather is the the owner of the project
  #
  def owner?(user)
    return true if user.admin?
    member =member(user)
    return false unless member
    member.owner?
  end

  #
  # Helper to return the current active project 
  # 
  def Team.current
    @@current ||= Project.current.team
  end

  def to_s
    "#{l(:label_team)}[#{name}]"
  end
  
  protected

  def create_default_team_access_control_list
    AccessControlList.from_team(self)
  end
end
