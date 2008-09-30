# Include hook code here
require 'alces_authenticated'

ActiveRecord::Base.send(:include,     Alces::AccessControl::AuthenticationModel)