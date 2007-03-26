##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
module  TaskItem 
 def name
   return parameter.name if parameter
 end


 def column_no
   return parameter.column_no if parameter
   return -1
 end
 
##
# Current experiment for this Value
# 
 def experiment
   context.task.experiment if context and context.task
 end
 
##
# Current process for this Value
#  
 def process
   context.task.process if context and context.task
 end

##
# Test whether Item is linked to a old version of process Instance
# Useful for auditing rules applied when the data was captured
# (old data does become invalid as process adapts unless resync is done)
# 
 def is_old_version
   return ( parameter.process == context.task.process)
 end
 
 def to_s
  return context.to_s + "=" + self.value.to_s
 end
 

end