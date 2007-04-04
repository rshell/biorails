# == Schema Information
# Schema version: 233
#
# Table name: experiment_logs
#
#  id             :integer(11)   not null, primary key
#  experiment_id  :integer(11)   
#  task_id        :integer(11)   
#  user_id        :integer(11)   
#  auditable_id   :integer(11)   
#  auditable_type :string(255)   
#  action         :string(255)   
#  name           :string(255)   
#  comment        :string(255)   
#  created_by     :string(255)   
#  created_at     :datetime      
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class ExperimentLog < ActiveRecord::Base

  belongs_to :auditable, :polymorphic => true
  belongs_to :experiment
  belongs_to :user

end
