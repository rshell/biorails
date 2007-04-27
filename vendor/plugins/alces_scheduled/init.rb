# Include hook code here
require 'alces_scheduled_collection'
require 'alces_scheduled_item'
ActiveRecord::Base.send(:include,     Alces::ScheduledCollection)
ActiveRecord::Base.send(:include,     Alces::ScheduledItem)
