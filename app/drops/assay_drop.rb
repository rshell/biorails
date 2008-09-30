# == Assay Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * protocols
# * project
# * team
# * parameters
# * queues
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class AssayDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes << :protocols << :parameters << :queues << :project << :team 
 
 def initialize(source,options={})
   super source
    @options  = options
 end
 
 def protocols
   liquify(@source.protocols) 
 end
 
 def project
   liquify(@source.project) 
 end

 def team
   liquify(@source.team) 
 end

 def parameters
   liquify(@source.parameters)    
 end
 
 def queues
   liquify(@source.queues)    
 end


 protected
 
end
