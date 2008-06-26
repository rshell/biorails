# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

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
   liquify(@source.contexts) 
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
