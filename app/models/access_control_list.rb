# == Schema Information
# Schema version: 359
#
# Table name: access_control_lists
#
#  id           :integer(4)      not null, primary key
#  content_hash :string(255)
#  team_id      :integer(4)
#

##
# == Description
#  Access Control List representing collection of rules granting to a entry.
#  This is build of rules granting teams or users access.
#
#  If there is a team id then this is the default access control list for the
#  team and may be updated, instead of copied when changing.
#
# == Copyright
#
# Copyright � 2008 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class AccessControlList < ActiveRecord::Base
  DEFAULT_SUBJECT ='data'
  DEFAULT_ACTION  ='create'

  SQL_UNLINKED_USERS = <<-SQL
     select u.* from users u where not exists 
     (select 1 from access_control_elements e
     where e.owner_id=u.id and e.owner_type='User' and e.access_control_list_id=?)
     order by u.name asc, u.id asc
SQL

  SQL_UNLINKED_TEAMS = <<-SQL
     select t.* from teams t where not exists 
     (select 1 from access_control_elements e
     where e.owner_id=t.id and e.owner_type='Team' and e.access_control_list_id=?)
     order by t.name asc,t.id asc
SQL

  SQL_PERMSSION_FILTER = <<-SQL
    select * 
     from access_control_elements e 
     inner join role_permissions p on (p.role_id = e.role_id) 
     where p.subject = ? 
     and   p.action = ? 
     and   e.access_control_list_id = ?
     and ((owner_type='User' and owner_id = ?) or  (owner_type='Team' 
           and exists (select 1 from memberships m where m.team_id=e.owner_id and m.user_id=? )))
     order by e.owner_type desc,e.id asc        
SQL
  

  has_many :rules  ,:class_name=>'AccessControlElement',:foreign_key=>:access_control_list_id,:include=>[:role] 
#
# Link to content to acl is applied to
#
  has_many :usages ,:class_name=>'ProjectElement', :foreign_key=>:access_control_list_id
#
# Optional Link to a team to specify this should be updated as team its based on changes
#
  belongs_to :team

  before_save :calculate_checksum
  before_update :can_update_used_list
  
   def to_s
     "acl[#{id}] #{rules.collect{|item| item.to_s }.join(',')}"
   end

   def unused_teams
      @unused_teams ||= Team.find_by_sql([SQL_UNLINKED_TEAMS,id] )      
   end

   def unused_users
      @unused_users ||= Team.find_by_sql([SQL_UNLINKED_USERS,id] )      
   end
   
   def roles
      @roles ||= ProjectRole.find(:all)
   end
   
   def users(subject=nil,action=nil)
     list =[]
     rules.each do |rule|
       if subject.nil? or action.nil? or rule.role.right?(subject,action)
         case rule.owner
         when Team
           for member in rule.owner.memberships
             unless list[member.user_id]
               list << ["(#{member.team.name}) #{member.user.name}",member.user_id]
             end
           end
         else
           list << [rule.owner.name,rule.owner_id]
         end
       end
     end
     list.uniq.sort{|a,b|a[0]<=>b[0]}
   end
#
# Standard permission? check on access control list
#   
   def permission?(user=nil,subject=DEFAULT_SUBJECT,action=DEFAULT_ACTION)
     user ||= User.current
     return true if user.admin?
     list = AccessControlElement.find_by_sql([SQL_PERMSSION_FILTER,subject.to_s,action.to_s,self.id,as_id(user),as_id(user)]) 
     (list.size>0 ? list.first : false)
   end   
   
   def right?(subject,action)
     permission?(User.current,subject.to_s,action.to_s)
   end
#
# See if the user as a specific role in the acl (teams ignored)
#
   def has_access?(owner,type='User')
     rules.find(:first,:order=>'owner_type desc',
                  :conditions=>{:owner_id=>as_id(owner),
                                :owner_type=>as_type(owner,type)})
   end   
   #
   # grant user has the role
   #
   def grant(owner,role,type='User')
      rule = has?(owner,role,type)
      unless rule
        rule = self.rules.create(:owner_id=>as_id(owner),:owner_type=>as_type(owner,type),:role_id=>as_id(role)) 
        self.calculate_checksum
      end
      rule
   end
   #
   # Test whether user has the role
   #
   def has?(owner,role,type='User')
      rules.exists?({:owner_id=>as_id(owner),:owner_type=>as_type(owner,type),:role_id=>as_id(role)})     
   end
   #
   # deny user has the role
   #
   def deny(owner,role,type='User')
     rule = self.rules.find(:first,:conditions=>{:owner_id=>as_id(owner),:owner_type=>as_type(owner,type),:role_id=>as_id(role)})
     if rule     
        rule.destroy
        self.calculate_checksum
     end
   end
   #
   # Copy existing list to create a editible list
   #
   def copy
     list = AccessControlList.create
     rules.each do |old|
        list.grant(old.owner_id,old.role_id,old.owner_type) 
     end
     list.save!
     list
   end
   #
   # Create a access control list from a team
   #
   def self.from_team(team)
     list = AccessControlList.find_by_team_id(team.id)
     unless list
       list = AccessControlList.create(:team_id=>team.id)
       list.grant(User.current, ProjectRole.owner) 
       list.grant(team, ProjectRole.member)  
       list.save!
     end
     list
   end
   #
   # Is the acl in use
   #
   def used?
      return false if new_record?
      @is_used ||= usages.exists?(:access_control_list_id=>self.id)   
   end
   #
   # If the user is changable
   #
   def changeable?
       new_record? and (usages.size  < 2)
   end

   def self.rebuild_checksums
     find(:all).each do |acl|
       acl.calculate_checksum
       acl.save
     end
   end
   #
   # Calculdate checksum to allow identical list to be easily spotted
   #
   def calculate_checksum
     data = rules.inject("") do |sum, item|
        sum << "#{item.owner_type}_#{item.owner_id}=>#{item.role_id} " 
    end
    self.content_hash = Digest::MD5.hexdigest(data)
   end

    #
    # Cant update list unless default team linked or unused
    #
    def can_update_used_list
      ((not used?) or team_id)     
    end
     
  protected

   def as_type(object,default)
     return object.class.class_name if object.is_a?(ActiveRecord::Base) 
     default
   end

   def as_id(object)
     return object.id if object.is_a?(ActiveRecord::Base) 
     object
   end

   
end
