class ProcessStepLink < ActiveRecord::Base
  belongs_to  :next_step, :class_name=> 'ProtocolVersion' , :foreign_key=>'to_process_step_id' #link to the previous step in a protocol flow
  belongs_to  :previous_step, :class_name=>'ProtocolVersion' , :foreign_key=>'from_process_step_id' #link to the next step in a protocol flow
  
end