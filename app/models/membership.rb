# == Schema Information
# Schema version: 281
#
# Table name: memberships
#
#  id                 :integer(11)   not null, primary key
#  user_id            :integer(11)   default(0), not null
#  project_id         :integer(11)   default(0), not null
#  role_id            :integer(11)   default(0), not null
#  is_owner           :boolean(1)    
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

class Membership < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
 acts_as_audited :change_log

  validates_uniqueness_of :user_id,:scope=>'team_id'
  validates_presence_of :user
  validates_presence_of :team
  validates_presence_of :role
  
  belongs_to :user, :class_name=>'User', :foreign_key =>'user_id'
  belongs_to :team, :class_name=>'Team', :foreign_key =>'team_id'
  belongs_to :role, :class_name=>'Role', :foreign_key =>'role_id' 
##
# Test if this role allows this action to this subject eg.
# 
#  allows?('study','new')
 def allows?(subject,action)  
   return (self.owner? or self.role.allow?(subject,action))
 end
 
 def owner?
   self.is_owner
 end
 
 def owner=(value)
   self.is_owner = value 
 end

 def owner
   self.is_owner.to_s  == self.connection.quoted_true
 end

 def experiments(limit = 10)
   Experiment.find(:all,
                   :limit=>limit,
                   :order=>'updated_at desc',
                   :conditions=>['team_id=? and updated_by_user_id=?',self.team_id,self.user_id])
 end
 
 def requests(limit = 10)
   Request.find( :all,
                 :limit=>limit,
                 :order=>'updated_at desc',
                 :conditions=>['team_id=? and updated_by_user_id=?',self.team_id,self.user_id])   
 end
 
 def tasks(limit = 10)
   Task.find(:all,
             :limit=>limit,
             :order=>'updated_at desc',
             :conditions=>['team_id=? and updated_by_user_id=?',self.team_id,self.user_id])   
 end

 def studies(limit = 10)
   Study.find(:all,
             :limit=>limit,
             :order=>'updated_at desc',
             :conditions=>['team_id=? and updated_by_user_id=?',self.team_id,self.user_id])   
 end

 def projects(limit = 10)
   Project.find(:all,
             :limit=>limit,
             :order=>'updated_at desc',
             :conditions=>['team_id=? and updated_by_user_id=?',self.team_id,self.user_id])   
 end
 
end
