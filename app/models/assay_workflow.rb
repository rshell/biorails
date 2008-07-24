# == Description
# Base Class for external analysis
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
# == Schema Information
# Schema version: 338
#
# Table name: assay_protocols
#
#  id                    :integer(11)   not null, primary key
#  assay_id              :integer(11)   
#  assay_stage_id        :integer(11)   
#  current_process_id    :integer(11)   
#  process_definition_id :integer(11)   
#  process_style         :string(128)   default(Entry), not null
#  name                  :string(128)   default(), not null
#  description           :string(1024)  default()
#  literature_ref        :string(1024)  default()
#  protocol_catagory     :string(20)    
#  protocol_status       :string(20)    
#  lock_version          :integer(11)   default(0), not null
#  created_at            :datetime      not null
#  updated_at            :datetime      not null
#  updated_by_user_id    :integer(11)   default(1), not null
#  created_by_user_id    :integer(11)   default(1), not null
#  type                  :string(255)   default(StudyProcess), not null
#


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
