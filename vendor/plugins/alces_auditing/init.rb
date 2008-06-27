# Include hook code here
require 'audited_model'

ActiveRecord::Base.send(:include,Alces::AuditedModel)
