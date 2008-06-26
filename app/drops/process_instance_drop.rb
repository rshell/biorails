# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
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
