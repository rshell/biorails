
class AssayWorkflow < AssayProtocol
  
   # Create a new ProcessInstance from this AssayProtocol
   #
   def new_version       
     process = ProcessFlow.new
     self.add_version(process)
     return process
   end 

   def multistep?
    true
  end    

   def summary
     "Workflow #{versions.size} versions"
   end   

end
