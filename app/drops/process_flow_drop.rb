# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
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
   liquify(@source.contexts) 
 end
 
 def folder
   liquify(@source.folder)    
 end
 
 def protocol
   liquify(@source.protocol)    
 end
 
 def experiments
   liquify(@source.experiments)    
 end
 
  def steps
   liquify(@source.steps)    
 end
 
 protected
 
end
