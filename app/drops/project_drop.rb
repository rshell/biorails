# == Project Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * folder
# * assays
# * experiments
# * requests
# * tasks
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class ProjectDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes << :folder << :experiments << :assays << :requests
 
 def initialize(source,options={})
   super source
    @options  = options
 end
  
 def folder
   liquify(@source.home)    
 end
 
 def assays
   liquify(@source.assays)    
 end

 def experiments
   liquify(@source.experiments)    
 end

  def requests
   liquify(@source.experiments)    
 end

 def tasks
   liquify(@source.tasks)    
 end
 

 
 protected
 
end
