# Include hook code here
require 'alces_scheduled_collection'
require 'alces_scheduled_item'
require 'alces_has_state'
ActiveRecord::Base.send(:include,     Alces::ScheduledCollection)
ActiveRecord::Base.send(:include,     Alces::ScheduledItem)
ActiveRecord::Base.send(:include,     Alces::WorkflowItem)
