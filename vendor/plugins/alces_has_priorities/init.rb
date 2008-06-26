# Include hook code here
require 'alces_has_priorities'
ActiveRecord::Base.send(:include,     Alces::HasPriorities)
