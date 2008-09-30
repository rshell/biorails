# == Schema Information
# Schema version: 359
#
# Table name: permissions
#
#  id      :integer(4)      not null, primary key
#  checked :boolean(1)
#  subject :string(255)     default(""), not null
#  action  :string(255)     default(""), not null
#

# == Description
# Base Class a Permission
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Permission < ActiveRecord::Base
  
  PROJECT_SUBJECTS = {
        'data'=> ['create','update','destroy','share','assign','verify'],
        'document'=> ['sign','witness','publish','withdraw']
      }
      
  USER_SUBJECTS = {
        'reports'=> ['build','use'],
        'project'=> ['build','use'],
        'execution'=> ['all'],
        'organization'=> ['build','use'],
        'catalogue'=>['admin'],
        'system'=>['admin']
       }
       
   Permission::USER_SUBJECTS.merge(Permission::PROJECT_SUBJECTS)

##
#
#
  def Permission.is_checked?(subject,action)
      subjects[subject.to_s] and subjects[subject.to_s].include?(action.to_s)
  end
##
# List of possible actions
#   
  def Permission.actions(subject)
      subjects[subject.to_s] || []
  end
##
# Build the cache of all the menus and rights for roles
# 
  def Permission.subjects(scope = nil)
    case scope
    when :current_user
      USER_SUBJECTS
    when :current_project
      PROJECT_SUBJECTS
   else
      @@ALL ||= USER_SUBJECTS.merge(PROJECT_SUBJECTS)
   end
  end

  def Permission.load_database
     for subject in subjects.keys
       for action in subjects[subject]
         unless Permission.location(subject,action)
           permission = Permission.new(:subject=>subject.to_s,:action=>action.to_s)
           permission.checked =  true
           permission.save!
         end
       end
     end
  end
  
  def Permission.location(subject,action)
     Permission.find(:first,:conditions=>['subject=? and action =?',subject.to_s, action.to_s])
  end

end
