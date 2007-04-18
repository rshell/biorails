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
    module AuthorizationService
    
      def self.included(base)
        base.extend(ClassMethods)
        if base.respond_to?(:helper_method)
          base.send :helper_method, :permission?
        end
      end
    
      module ClassMethods
                   
          def use_authorization (subject , options={} )
            
            write_inheritable_attribute(:rights_actions,  options[:actions] || [:list,:show,:edit,:update,:new,:create,:destroy] )
            write_inheritable_attribute(:rights_subject,  subject || '*' )
            write_inheritable_attribute(:rights_source,   options[:rights] ||  :current_user  )

            class_inheritable_reader :rights_actions
            class_inheritable_reader :rights_subject
            class_inheritable_reader :rights_source     

            before_filter :authorization, :only => rights_actions

            include Alces::AccessControl::AuthorizationService::ControllerInstanceMethods
            logger.info  "use_authorization "
          end
      end
     
      module ControllerInstanceMethods    
          ##
          # Get the list of rights for the controller
          # 
          def authorized?(action) 
            return true unless self.class.rights_actions.any?{|i| i.to_s == action.to_s}
            rights = self.send( rights_source )  
            return ( !rights.nil? and current_user and (current_user.admin || rights.permission?(current_user, self.class.rights_subject, action )  ) )
          end   
          ##
          # authorization 
          #
          def authorization
             logger.info "Authorization #{session[:current_username]} #{params[:controller]} #{params[:action]}"  
             unless self.authenticate    
                  return false     
             end     
             if authorized?(params[:action])
                  return true
             end 
             return false     
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
         
          def access_control_rights ( role, relation_options={} )
              belongs_to( role,relation_options)
              write_inheritable_attribute(:access_control_list,  role  )
              class_inheritable_reader :access_control_list
              include Alces::AccessControl::AuthorizationModel::ModelPermissionsInstanceMethods
          end

          def access_control_list( rights , relation_options = {})
              has_many rights, relation_options do
                  def permission?(user,subject,action)        
                    return RolePermission.find_by_sql( 
                    ["select p.* from role_permissions p inner join memberships m on m.role_id = p.role_id where m.user_id=?  and m.project_id= ? and p.subject = ?  and p.action = ?",
                     user.id, proxy_owner.id, subject.to_s, action.to_s])
                  end
              end                                                                                                                 
              write_inheritable_attribute( :access_control_list, rights )
              class_inheritable_reader :access_control_list
              include Alces::AccessControl::AuthorizationModel::ModelPermissionsInstanceMethods
          end
      end
  

##------------------------------------------------------------------------------------------------------------------------------      
      module ModelPermissionsInstanceMethods
        ##
        # check the permissions
        #
        def permission?(user,subject,action)        
          return self.send(access_control_list).permission?(user,subject,action)
        end

      end
    end
  end
end