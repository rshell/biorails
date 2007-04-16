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
#                     :rights => :current_project 
#
    module AuthorizationService
    
      def self.included(base)
        base.extend(ClassMethods)
        if base.respond_to?(:helper_method)
          base.send :helper_method, :permission?
        end
      end
    
      module ClassMethods
         
          def use_authorization (options={} )
            write_inheritable_attribute(:authorization_options, { :subject => '*',
                                                                  :actions =>  [:list,:show,:edit,:update,:new,:create,:destroy],
                                                                  :authenticate => :current_user,
                                                                  :rights => :current_user } )
            class_inheritable_reader :authorization_options
            include Alces::AccessControl::AuthorizationService::ControllerInstanceMethods
          end
          ##
          # Get the list of actions which need authorization for this controller
          def rights_actions
               authorization_options[:actions]
          end
          ##
          # Test if this as actions which needs to be checked
          def rights_actions?(value)
             authorization_options[:subject].detect{|i|i.to_s == action.to_s}
          end
      end
     
      module ControllerInstanceMethods
          ##
          # The the subject scope for authorization
          #
          def rights_subject
              self.send( authorization_options[:subject].to_s )   
          end
          ##
          # get the current principal for authorization
          # 
          def rights_principal
              self.send( authorization_options[:authenticate].to_s )   
          end       
          ##
          # Get the list of rights for the controller
          # 
          def rights_list
              self.send( authorization_options[:rights_via].to_s )   
          end
  
          def permission?(action) 
            return true unless rights_actions?(action)
            rights_list.permission?(rights_principal, rights_subject, action )  
          end        
      end    
    end #AuthorizedService
###
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
         
          def access_control_via ( role, relation_options={} )
              belongs_to( role,relation_options)
              write_inheritable_attribute(:access_control_list_options, { :role => role } )
              class_inheritable_reader :access_control_list_options
              include Alces::AccessControl::AuthorizationModel::ModelRoleRightInstanceMethods
          end

          def access_control_list( rights , options = {})
           
            write_inheritable_attribute( :access_control_list_options, { :rights => rights,
                                                                         :role =>  options[:role] || :role,
                                                                         :user =>  options[:user] || :user})
            class_inheritable_reader :access_control_list_options
            has_many rights, :dependent => :destroy do
               def scope(user)
                 find(:first, :conditions=>["#{access_control_list_options[:user]}_id",user.id]).send( access_control_list_options[:role])              
               end
            end
            has_many :users, :through => rights, :source => :user                                                             
            has_many :roles, :through => rights, :source => :role                                                                                                                       
            include Alces::AccessControl::AuthorizationModel::ModelPerUserRightsInstanceMethods
          end
      end
  

##------------------------------------------------------------------------------------------------------------------------------      
      module ModelPerUserRightsInstanceMethods
        ##
        # reset the password
        #
        def permission?(user,subject,action)        
          self.send(access_control_list_options[:role].to_s).permission?(subject,action)  
        end

        def rights(user)
          self.send( access_control_list_options[:rights].to_s ).scope(user)
        end 
      end
##------------------------------------------------------------------------------------------------------------------------------      
      
      module ModelRoleRightInstanceMethods
        ##
        # reset the password
        #
        def permission?(user,subject,action)
          self.send(access_control_list_options[:role].to_s).permission?(subject,action)
        end

        def rights(user = nil)
          self.send(User.access_control_list_options[:role].to_s)
        end 
        
      end
    end
  end
end