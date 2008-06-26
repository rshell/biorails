# == Schema Information
# Schema version: 306
#
# Table name: experiment_statistics
#
#  id                 :float         primary key
#  experiment_id      :integer(11)   not null
#  assay_parameter_id :integer(11)   not null
#  parameter_role_id  :integer(11)   not null
#  parameter_type_id  :integer(11)   not null
#  data_type_id       :integer(11)   not null
#  avg_values         :float         
#  stddev_values      :float         
#  num_values         :float         
#  num_unique         :float         
#  max_values         :float         
#  min_values         :float         
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class ExperimentStatistics < ActiveRecord::Base
 belongs_to :experiment
 belongs_to :assay_parameter, :class_name =>'AssayParameter',:foreign_key => 'assay_parameter_id'
 belongs_to :role,            :class_name =>'ParameterRole', :foreign_key => 'parameter_role_id'
 belongs_to :type,            :class_name =>'ParameterType', :foreign_key => 'parameter_type_id'
 belongs_to :data_type,       :class_name =>'DataType',       :foreign_key => 'data_type_id'
end
