# == Schema Information
# Schema version: 281
#
# Table name: study_logs
#
#  id             :integer(11)   not null, primary key
#  study_id       :integer(11)   
#  user_id        :integer(11)   
#  auditable_id   :integer(11)   
#  auditable_type :string(255)   
#  action         :string(255)   
#  name           :string(255)   
#  comments       :string(255)   
#  changes        :text          
#  created_by     :string(255)   
#  created_at     :datetime      
#

##
# Timeline for a Study
# 
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class StudyLog < ActiveRecord::Base

  belongs_to :auditable, :polymorphic => true
  belongs_to :study
  belongs_to :user
  
end
