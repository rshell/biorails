##
# Copyright © 2006 Alces Ltd All Rights Reserved
# Author: Robert Shell
# See license agreement for additional rights
##
#
##
#This is setup for the  acts_as_authenticated method This is based 
#onf a list of rights linked to the source object. This relies for the following
# 
# 1) User directly as role
# 
#    access_control_via :role
# 
# 2) User has rights via the current scope object
# 
#   access_control_list :rights
# 
# In either case once the model is setup can ask for permissions on the object via
#
#   permission?(user,subject,action)
#   rights(user)
# 
# In use of the controllor the authorization can be simply defined as a follows
# 

#  
#  
# 
#
module Alces
  module AccessControl

##
# Add authorization subsystems to the service level.
# 
# by default the system will check the global rights for all subjects and default crud operations
# 
#  use_authorization  :subject => :project ,
#                     :actions => [:list,:show,:edit,:update,:new,:create,:destroy],
#                     :authenticate => :current_user,
#                     :rights => :current_user
#
# In cases of failure the sub system called the handle 'show_access_denied'
# 
#
    module AuthorizationService
      #
      # initialize 
      #
      def self.included(base)
        base.extend(ClassMethods)
        if base.respond_to?(:helper_method)
          base.send :helper_method, :permission?
        end
      end
      #
      # Define the main additions to ActionController
      # 
      #    use_authorization :project,
      #              :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
      #              :rights =>  :current_project  
      #
      # This provides the descriptive definition of a authorization rules
      # 
      # Creates class attributes
      #   * rights_actions
      #   * rights_subjects
      #   * rights_source 
      #
      # Create a before filter for authorization called authorization
      #   
      #  In the package this is dependent on  
      #
      #
      module ClassMethods
                   
          def use_authorization (subject , options={} )
            
            write_inheritable_attribute(:rights_actions,  options[:actions] || [:list,:show,:edit,:update,:new,:create,:destroy] )
            write_inheritable_attribute(:rights_subject,  subject || '*' )
            write_inheritable_attribute(:rights_source,   options[:rights] ||  :current_user  )

            class_inheritable_reader :rights_actions
            class_inheritable_reader :rights_subject
            class_inheritable_reader :rights_source     

            before_filter :authorization, :only => options[:rights_actions]

            include Alces::AccessControl::AuthorizationService::ControllerInstanceMethods
          end
      end
      #
      # Extra to allow access control to be setup in the controller
      #
      #
      module ControllerInstanceMethods    
          ##
          # Get the list of rights for the controller
          # 
          # @param action action to check in the current scope
          # @return true/false with no rule specified the default is allowed
          # 
          def allow?(action) 
            return true unless self.class.rights_actions.any?{|i| i.to_s == action.to_s}
            return true if User.current.admin == true
            rights = self.send( rights_source )  
            if rights 
               return rights.permission?(User.current, self.class.rights_subject, action )  
            else
               logger.error "No Rights source found for this controller"
            end
            return true
          end   
          ##
          # authorization 
          #
          def authorization
             logger.info "Authorization #{session[:current_username]} #{self.class.rights_subject} #{params[:action]}"  
             unless self.authenticate  
                  flash[:error]= "User #{session[:current_username]} authentication does not appear valid "  
                  logger.warn flash[:error]
                  return show_login
                  
             end     
             if allow?(params[:action])
                  logger.debug "#{session[:current_username]} is authorized"
                  return true
             end 
             if rights_source == :current_user
               flash[:warning]= "No permission for action [#{params[:action]}] on [#{self.class.rights_subject}] with currently user #{current_username}  "  
               flash[:info]= "See system administration if you really need to do this level of liability(rights) in the sytsem " 
               logger.warn flash[:warning]
             else
               flash[:warning]= "No permission for action [#{params[:action]}] on [#{self.class.rights_subject}] with currently project #{current_project.name} "  
               flash[:info]= "See Team Owner if you really need to do this  " 
               logger.warn flash[:warning]
             end
             return show_access_denied              
          end         
      end    
    end #AuthorizedService

##------------------------------------------------------------------------------------------------------------------------------      
# The implements a rights model
#  
#  * access_control_via for simple global models
#  * access_control_list for per user models
#
# class Project < ActiveRecord::Base
#    access_control_list  :memberships
# end
#  
    module AuthorizationModel

      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
          #
          #  has_ownership is used to make a model be owned by a another model which in turn provides
          #  access control at the model level.
          #  
          #  access_control_via :team
          #  
          #  This add the following functions to the nodel
          #  
          #   * permission?(user,subject,action)
          #   * visible?
          #   * changable?  
          #   * allows?(action)
          #   * find_visible(*args)
          #    
          #
          #
          def access_control_via( owner, relation_options ={})
            
              belongs_to owner,relation_options
              
              write_inheritable_attribute(:access_control_via,  owner  )
              class_inheritable_reader :access_control_via
              
              include Alces::AccessControl::OwnedInstanceMethods
              class_eval do
                  extend Alces::AccessControl::OwnedClassMethods
              end
          end          
          #
          # This provides a simple role based security via a instance of the role model linked 
          # as in a belongs_to relationship with this model. The idea a role which in terms
          # has a long list of role_permissions linked to it.
          #
          #  access_control_rights :role      
          # 
          #  This add the following functions to the nodel
          #  
          #   * permission?(user,subject,action)
          #
          def access_control_role ( role, relation_options={} )
              
              belongs_to( role,relation_options)
              
              write_inheritable_attribute(:access_control_list,  role  )
              class_inheritable_reader :access_control_list
              
              include Alces::AccessControl::RoleInstanceMethods
              class_eval do
                  extend Alces::AccessControl::RoleClassMethods
              end
          end
          #
          # This provides a full list of user+roles into a mobel. This can be seen a list
          # list of specific role for each user in the Access control list. In real life this is
          # most commonly in the form of a membership list. 
          #
          #   access_control_list  :memberships , :dependent => :destroy 
          #
          #  This add the following functions to the nodel
          #  
          #   * permission?(user,subject,action)
          #
          def access_control_list( rights , relation_options = {})
            
             has_many rights, relation_options do
              
                def permission?(user,subject,action)   
                    return true if user.admin?
                    member = find(:first, :conditions=>['user_id = ?',user.id])
                    return false unless member
                    return member.owner? || member.allows?(subject,action)
                end
                
              end                                                                                                                 
            
              write_inheritable_attribute( :access_control_list, rights )
              class_inheritable_reader :access_control_list

              include Alces::AccessControl::ListInstanceMethods
              class_eval do
                  extend Alces::AccessControl::ListClassMethods
              end
          end
      end
   end


##------------------------------------------------------------------------------------------------------------------------------      
   module ListInstanceMethods
        ##
        # check the permissions
        # 
        #  @param user a valid user to check the firsts of
        #  @param subject sybmol/string for area
        #  @param action symbol/string for the action to check
        #  @return true/false to passing check
        #
        def permission?(user,subject,action)        
          return self.send(access_control_list).permission?(user,subject,action)
        end
        #
        #  If the record published      
        #        
        def published?
          return true if self.attributes[:status_id] == Alces::ScheduledItem::COMPLETED 
          return true if self.attributes[:published] == '1'
          return false
        end
        #
        # Check whether object should be visible in this context
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.
        #
        def visible?    
          return true 
        end
        #
        # See if record is changeble in the current context
        #
        def changable?
          return true if self.new_record?
          return false if self.published?
          return self.visible? 
        end
        #
        # Check whether a action is allowed in the context of a 
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.
        #
        def allows?( action ,scope ='data_crud')
          return self.permission?(User.current, scope, action )
        end
    end

    module ListClassMethods
      #
        # Filtered Find with only published, owned or accessable records returned
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.
        #
        def find_visible(*args)
           self.find(*args)
        rescue Exception => ex
           logger.info "Failed to find object "+ex.message
           return nil
        end  
    end  
##------------------------------------------------------------------------------------------------------------------------------      
   module RoleInstanceMethods
        ##
        # check the permissions
        # 
        #  @param user a valid user to check the firsts of
        #  @param subject sybmol/string for area
        #  @param action symbol/string for the action to check
        #  @return true/false to passing check
        #
        def permission?(user,subject,action)             
          return self.send(access_control_list).permission?(user,subject,action)
        end
        #
        # Check whether object should be visible in this context
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.
        #
        def visible?    
          return true 
        end
        #
        #  If the record published      
        #        
        def published?
          return true if self.attributes[:status_id] == Alces::ScheduledItem::COMPLETED 
          return true if self.attributes[:published] == '1'
          return false
        end
        #
        # See if record is changeble in the current context
        #
        def changable?
          return true if self.new_record?
          return false if self.published?
          return self.visible? 
        end
        #
        # Check whether a action is allowed in the context of a 
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.

        def allows?( action ,scope ='data_crud')
          return self.permission?(User.current, scope, action )
        end

      end

    module RoleClassMethods
      #
        # Filtered Find with only published, owned or accessable records returned
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.
        #
        def find_visible(*args)
           self.find(*args)
        rescue Exception => ex
           logger.info "Failed to find object "+ex.message
           return nil
        end  
    end      
##------------------------------------------------------------------------------------------------------------------------------      

      module OwnedClassMethods
        #
        # Filtered Find with only published, owned or accessable records returned
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.
        #
        def find_visible(*args)
            items = []
            items << ["exists (select 1 from memberships m where m.user_id=? and m.team_id=#{self.table_name}.#{self.access_control_via}_id)",User.current.id]
            items << ["published = ?",1] if self.columns.any?{|c|c.name =='published'}
            items << ['created_by_user_id = ?',User.current.id] if self.columns.any?{|c|c.name =='created_by_user_id'}
            sql_elements = []
            values = []
            items.each do |item|
              sql_elements <<  item[0]
              values << item[1]
            end
            self.with_scope( :find => {:conditions=> [sql_elements.join(" or "),values].flatten } )  do
               self.find(*args)
           end
         rescue Exception => ex
           logger.info "Failed to find object "+ex.message
           return nil
         end  
    end
      #
      #
      #
      #
    module OwnedInstanceMethods
        ##
        # check the permission to do stuff
        # 
        #  @param user a valid user to check the firsts of
        #  @param subject sybmol/string for area
        #  @param action symbol/string for the action to check
        #  @return true/false to passing check
        #
        def permission?(user,subject,action)        
          return self.send(access_control_via).permission?(user,subject,action)
        end
        #
        #  If the record published      
        #        
        def published?
          return true if self.attributes[:status_id] == Alces::ScheduledItem::COMPLETED 
          return true if self.attributes[:published] == '1'
          return false
        end
        #
        # Check whether object should be visible in this context
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.
        #
        def visible?    
          return true if self.published?
          return self.send(access_control_via).member(User.current)           
          return (self.created_by_user_id == User.current.id) && (self.updated_by_user_id == User.current.id)
        end
        #
        # See if record is changeble in the current context
        #
        def changable?
          return true if self.new_record?
          return false if self.published?
          return self.visible? 
        end
        #
        # Check whether a action is allowed in the context of a 
        #   * Is published
        #   * If current user is a member of the team owning the record
        #   * If current user was the last author of the object.
        #
        def allows?( action ,scope ='data_crud')
          return self.permission?(User.current, scope, action )
        end
        
    end
      
  end
end
