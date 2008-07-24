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
# Table name: assay_statistics
#
#  id                 :integer(11)   primary key
#  assay_parameter_id :integer(11)   
#  assay_id           :integer(11)   
#  parameter_role_id  :integer(11)   default(0), not null
#  parameter_type_id  :integer(11)   default(0), not null
#  data_type_id       :integer(11)   default(0), not null
#  avg_values         :float         
#  stddev_values      :float         
#  num_values         :integer(21)   default(0), not null
#  num_unique         :integer(21)   default(0), not null
#  max_values         :float         
#  min_values         :float         
#

class AssayStatistics < ActiveRecord::Base
  
 belongs_to :assay, :class_name =>'Assay',:foreign_key => 'assay_id'

 belongs_to :assay_parameter, :class_name =>'AssayParameter',:foreign_key => 'assay_parameter_id'
 belongs_to :role,            :class_name =>'ParameterRole', :foreign_key => 'parameter_role_id'
 belongs_to :type,            :class_name =>'ParameterType', :foreign_key => 'parameter_type_id'
 belongs_to :data_type,       :class_name =>'DataType',       :foreign_key => 'data_type_id'

end
