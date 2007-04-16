# Include hook code here
require 'alces_authenticated'
require 'alces_authorized'
#require 'alces_authenticated'

#require 'access_control'
#require 'acts_as_authenticated'
#require File.dirname(__FILE__) + '/lib/role'
#require File.dirname(__FILE__) + '/lib/extensions'

#ActionController::Base.send(:include, AccessControl::AuthenticationSystem::InstanceMethods)
#ActionController::Base.send(:include, AccessControl::AuthenticationSystem)
#ActionController::Base.send(:include, AccessControl::AuthorizationSystem::InstanceMethods)
ActionController::Base.send(:include, Alces::AccessControl::AuthorizationService)
ActiveRecord::Base.send(:include,     Alces::AccessControl::AuthorizationModel)
ActiveRecord::Base.send(:include,     Alces::AccessControl::AuthenticationModel)