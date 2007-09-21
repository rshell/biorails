# == Schema Information
# Schema version: 280
#
# Table name: process_statistics
#
#  id                  :integer(11)   default(0), not null, primary key
#  study_parameter_id  :integer(11)   
#  protocol_version_id :integer(11)   
#  parameter_id        :integer(11)   
#  parameter_role_id   :integer(11)   
#  parameter_type_id   :integer(11)   
#  avg_values          :float         
#  stddev_values       :float         
#  num_values          :integer(20)   default(0), not null
#  num_unique          :integer(20)   default(0), not null
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
