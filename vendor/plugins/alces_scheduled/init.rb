# Include hook code here
require 'alces_scheduled_collection'
ActiveRecord::Base.send(:include,     Alces::ScheduledCollection)
