# == Schema Information
# Schema version: 359
#
# Table name: process_step_links
#
#  id                   :integer(4)      not null, primary key
#  from_process_step_id :integer(4)
#  to_process_step_id   :integer(4)
#  mandatory            :boolean(1)
#

# == Description
# This represents the linkage between to process steps
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
class ProcessStepLink < ActiveRecord::Base
  belongs_to  :next_step, :class_name=> 'ProtocolVersion' , :foreign_key=>'to_process_step_id' #link to the previous step in a protocol flow
  belongs_to  :previous_step, :class_name=>'ProtocolVersion' , :foreign_key=>'from_process_step_id' #link to the next step in a protocol flow
  
end
