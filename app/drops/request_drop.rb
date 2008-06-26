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
 extra_attributes << :services << :items <<  :project
 
 def initialize(source,options={})
   super source
    @options  = options
 end
 
 def services
   liquify(@source.services) 
 end
 
 def items
   if @source.list
     liquify(@source.list.items)    
   end
 end
 
 def project
   liquify(@source.project)    
 end
 
 protected
 
end
