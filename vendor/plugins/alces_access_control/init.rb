# Include hook code here
require 'alces_authorized'

ActionController::Base.send(:include, Alces::AccessControl::AuthorizationService)
ActiveRecord::Base.send(:include,     Alces::AccessControl::AuthorizationModel)
