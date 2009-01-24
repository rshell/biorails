# == Experiment Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * project
# * process
# * assay
# * tasks
# * statistics
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
#
class ExperimentDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes << :project << :process << :tasks << :statistics << :assay
 
 def initialize(source,options={})
   super source
   @options  = options
 end
 
 def project
   liquify(@source.project) 
 end

 def process
   liquify(@source.process) 
 end
 
 def assay
   liquify(@source.assay) 
 end
 
 def state
   @source.folder.state_name
 end
 
 def started
   @source.started_at.strftime("%Y:%m:%d")
 end
 
 def finished
   @source.finished_at.strftime("%Y:%m:%d")
 end
 
 def expected
   @source.expected_at.strftime("%Y:%m:%d")
 end
 
 
 def tasks
   @source.tasks   
 end
 
 def statistics
   @source.stats   
 end
 
 protected

end
