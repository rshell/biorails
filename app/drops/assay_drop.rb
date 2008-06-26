# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

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
 
 def parameters
   liquify(@source.queues)    
 end


 protected
 
end
