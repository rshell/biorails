# == Process Instance Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * contexts
# * folder
# * protocol
# * tasks
# * parameters
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class ProcessInstanceDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes << :contexts << :parameters << :tasks << :protocol  << :folder
 
 def initialize(source,options={})
   super source
    @options  = options
 end
 
 def contexts
   liquify(@source.contexts)
 end
 
 def folder
   liquify(@source.folder)    
 end
 
 def protocol
   liquify(@source.protocol)    
 end

 def tasks
   liquify(@source.tasks)    
 end
 
  def parameters
   liquify(@source.parameters)    
 end
 
 protected
 
end
