# == Schema Information
# Schema version: 306
#
# Table name: permissions
#
#  id      :integer(11)   not null, primary key
#  checked :boolean(1)    
#  subject :string(255)   default(), not null
#  action  :string(255)   default(), not null
#

class Permission < ActiveRecord::Base
  cattr_accessor :cached_subjects
  cattr_accessor :cached_controllers

##
#
#
  def Permission.is_checked?(subject,action)
      return ( Permission.possible_subjects[subject] and 
               Permission.possible_subjects[subject].detect{|item|item.to_s == action.to_s})
  end
##
# List of possible actions
#   
  def Permission.possible_actions(subject)
      Permission.possible_subjects[subject] || []
  end
##
# Build the cache of all the menus and rights for roles
# 
  def Permission.possible_subjects
     return @@cached_subjects if @@cached_subjects
     return Permission.reload   
  end

  def Permission.subjects(rights_source)
    subjects = {}
    @@cached_controllers||= Permission.controllers   
     for key in @@cached_controllers.keys
        controller = Permission.controllers[key]
        if controller.respond_to?(:rights_source)
           if  controller.rights_source.to_s == rights_source.to_s
             subjects[controller.rights_subject.to_s] ||=['*']
             subjects[controller.rights_subject.to_s].concat(controller.rights_actions)
             subjects[controller.rights_subject.to_s] = subjects[controller.rights_subject.to_s].uniq
           end
        end
     end
    return subjects
  end
##
# Force a reload of all the controllers,models,methods and cache infomation
# 
  def Permission.reload   
     @@cached_subjects = {}
     @@cached_controllers = nil 
     for key in Permission.controllers.keys
        controller = Permission.controllers[key]
        if controller.respond_to?(:rights_subject)           
           @@cached_subjects[controller.rights_subject.to_s] ||=['*']
           @@cached_subjects[controller.rights_subject.to_s].concat(controller.rights_actions)
           @@cached_subjects[controller.rights_subject.to_s] = @@cached_subjects[controller.rights_subject.to_s].uniq
        else   
           @@cached_subjects[key] ||=['*']
        end
     end
     return @@cached_subjects
  end
   
##
#List all the controllers 
#  
 def Permission.controllers
    unless @@cached_controllers and  @@cached_controllers.size>1  
      @@cached_controllers = {}
      logger.info "Reloading   Role.controllers"
      rbfiles = File.join("#{RAILS_ROOT}/app/controllers/**", "*.rb")  
      for file in Dir.glob(rbfiles) do
        begin
          load file
        rescue
          logger.debug "Couldn't load file '#{file}' (already loaded?)"
        end
      end
      @@cached_controllers = Hash.new    
      ObjectSpace.each_object(Class) do |klass|
        if klass.respond_to? :controller_name
            if klass.superclass.to_s == ApplicationController.to_s
              @@cached_controllers[klass.controller_name] = klass
            end
        end
      end
    end    
    return @@cached_controllers
 end


  def Permission.load_database
     for subject in Permission.possible_subjects.keys
       for action in Permission.possible_actions(subject)
         unless Permission.location(subject,action)
           permission = Permission.new(:subject=>subject.to_s,:action=>action.to_s)
           permission.checked =  true
           permission.save
         end
       end
     end
  end
  
  def Permission.location(subject,action)
     Permission.find(:first,:conditions=>['subject=? and action =?',subject.to_s, action.to_s])
  end

end
