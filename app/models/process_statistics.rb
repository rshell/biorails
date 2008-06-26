# == Schema Information
# Schema version: 306
#
# Table name: process_statistics
#
#  id                  :integer(11)   not null, primary key
#  assay_parameter_id  :integer(11)   not null
#  protocol_version_id :integer(11)   not null
#  parameter_id        :integer(11)   not null
#  parameter_role_id   :integer(11)   not null
#  parameter_type_id   :integer(11)   not null
#  avg_values          :float         
#  stddev_values       :float         
#  num_values          :float         
#  num_unique          :float         
#  max_values          :float         
#  min_values          :float         
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class ProcessStatistics < ActiveRecord::Base

 belongs_to :process, :class_name =>'ProtocolVersion',:foreign_key =>'protocol_version_id'
 belongs_to :parameter
 belongs_to :role,    :class_name =>'ParameterRole',:foreign_key =>'parameter_role_id'
 belongs_to :type,    :class_name =>'ParameterType',:foreign_key =>'parameter_type_id'

end
