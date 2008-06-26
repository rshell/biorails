# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

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
