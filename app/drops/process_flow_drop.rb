# == Process Flow Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * contexts
# * folder
# * protocol
# * experiments
# * steps
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class ProcessFlowDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes <<  :steps << :experiments << :protocol  << :folder
 
 def initialize(source,options={})
   super source
    @options  = options
 end
 
 def contexts
  @source.contexts
 end
 
 def folder
   liquify(@source.folder)    
 end
 
 def protocol
   liquify(@source.protocol)    
 end
 
 def experiments
   @source.experiments   
 end
 
  def steps
   @source.steps    
 end
 
 protected
 
end
