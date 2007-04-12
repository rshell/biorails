# == Schema Information
# Schema version: 233
#
# Table name: parameter_types
#
#  id              :integer(11)   not null, primary key
#  name            :string(50)    default(), not null
#  description     :string(255)   default(), not null
#  weighing        :integer(11)   default(0), not null
#  lock_version    :integer(11)   default(0), not null
#  created_by      :string(32)    default(), not null
#  created_at      :datetime      not null
#  updated_by      :string(32)    default(), not null
#  updated_at      :datetime      not null
#  data_concept_id :integer(11)   
#  data_type_id    :integer(11)   
#  storage_unit    :string(255)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#

class ParameterType < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name
  
  belongs_to :data_type
  belongs_to :data_concept

  has_many :parameters, :dependent => :destroy

  has_many :study_parameters, :dependent => :destroy

  validates_presence_of :data_type_id
  validates_presence_of :description

#
# Overide context_columns to remove all the internal system columns.
# 
  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }
  end
  ##
# Test usages of the parameter type
# 
  def not_used
    return (study_parameters.size==0 and parameters.size==0)
  end 
  
  def ParameterType.find_by_role(role)
    ParameterType.find_by_sql(
    ['select t.* from parameter_types t, study_parameters s '+
     'where t.id = s.parameter_type_id and s.parameter_role_id = ? ',role.id])
  end          
  
  def ParameterType.find_by_study_role(study,role)
    ParameterType.find_by_sql(
    ['select t.* from parameter_types t, study_parameters s where t.id = s.parameter_type_id' + 
     'and s.parameter_role_id=? and s.study_id=? ',role.id,study.id])        
  end


end
