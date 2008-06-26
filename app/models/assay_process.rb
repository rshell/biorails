# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class AssayProcess < AssayProtocol


   # Create a new ProcessInstance from this AssayProtocol
   #
   def new_version(with_context=true)       
     process = ProcessInstance.new
     self.add_version(process)
     process.new_context(nil,'top') if with_context
     return process
   end      
   
   def summary
     "Process #{versions.size} versions"
   end 
   
end
