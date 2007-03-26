# == Schema Information
# Schema version: 123
#
# Table name: task_statistics
#
#  id                :integer(20)   primary key
#  task_id           :integer(11)   
#  parameter_id      :integer(11)   
#  parameter_role_id :integer(11)   
#  parameter_type_id :integer(11)   
#  data_type_id      :integer(11)   
#  avg_values        :float         
#  stddev_values     :float         
#  num_values        :integer(20)   default(0), not null
#  num_unique        :integer(20)   default(0), not null
#  max_values        :binary        
#  min_values        :binary        
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
###
# Summary Stats for a Tasks Parameters
# 
class TaskStatistics < ActiveRecord::Base

 belongs_to :task,            :class_name =>'Task',           :foreign_key => 'task_id'
 belongs_to :study_parameter, :class_name =>'StudyParameter', :foreign_key => 'study_parameter_id'
 belongs_to :parameter,       :class_name =>'Parameter',      :foreign_key => 'parameter_id'
 belongs_to :role,            :class_name =>'ParameterRole',  :foreign_key => 'parameter_role_id'
 belongs_to :type,            :class_name =>'ParameterType',  :foreign_key => 'parameter_type_id'
 belongs_to :data_type,       :class_name =>'DataType',       :foreign_key => 'data_type_id'


end
