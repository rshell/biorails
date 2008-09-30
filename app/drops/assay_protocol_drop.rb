# == Assay Protocol Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * folder
# * versions
# * assay
# * tasks
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class AssayProtocolDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes << :versions << :tasks << :assay << :folder
 
 def initialize(source,options={})
   super source
    @options  = options
 end

 def folder
   liquify(@source.folder)    
 end
 
 def versions
   liquify(@source.versions)    
 end

 def assay
   liquify(@source.assay)    
 end

 def tasks
   liquify(@source.tasks)    
 end
  
 protected
 
end
