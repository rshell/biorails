# == Schema Information
# Schema version: 233
#
# Table name: experiment_statistics
#
#  id                 :integer(20)   primary key
#  experiment_id      :integer(11)   
#  study_parameter_id :integer(11)   
#  parameter_role_id  :integer(11)   
#  parameter_type_id  :integer(11)   
#  data_type_id       :integer(11)   
#  avg_values         :float         
#  stddev_values      :float         
#  num_values         :integer(20)   default(0), not null
#  num_unique         :integer(20)   default(0), not null
#  max_values         :float         
#  min_values         :float         
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class ExperimentStatistics < ActiveRecord::Base
 belongs_to :experiment
 belongs_to :study_parameter, :class_name =>'StudyParameter',:foreign_key => 'study_parameter_id'
 belongs_to :role,            :class_name =>'ParameterRole', :foreign_key => 'parameter_role_id'
 belongs_to :type,            :class_name =>'ParameterType', :foreign_key => 'parameter_type_id'
 belongs_to :data_type,       :class_name =>'DataType',       :foreign_key => 'data_type_id'
end
