# Include hook code here
require 'alces_task_item'
ActiveRecord::Base.send(:include,     Alces::TaskItem)