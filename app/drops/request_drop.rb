# == Project Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * folder
# * services
# * items
# * project
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
 extra_attributes << :services << :items <<  :project
 
 def initialize(source,options={})
   super source
    @options  = options
 end
 
 def folder
   liquify(@source.folder) 
 end

 def services
   @source.services 
 end
 
 def items
   if @source.list
     @source.list.items
   else
     []
   end
 end
 
 def project
   liquify(@source.project)    
 end
 
 protected
 
end
