# == Schema Information
# Schema version: 359
#
# Table name: parameter_roles
#
#  id                 :integer(4)      not null, primary key
#  name               :string(50)      default(""), not null
#  description        :string(1024)    default(""), not null
#  weighing           :integer(4)      default(0), not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# This represents the global role for a paramater definition. It repesents the 
# basic dimension for usage of a parameter. Its is expected to contain instances like
# raw measurement, condition, setting ,result etc.
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ParameterRole < ActiveRecord::Base
   acts_as_dictionary :name 
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name,:case_sensitive=>false

##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Parameters linked to this role
#
  has_many :parameters, :dependent => :destroy do
     #
     # Limit set to contexts using the the a object
     #
     def using(item,in_use=false)
       template = 'parameters'
       if in_use
         template = "exists (select 1 from task_contexts where task_contexts.parameter_context_id = parameters.parameter_context_id) and #{template}"
       end
       case item
       when ParameterType  then  find(:all,:conditions=>["#{template}.parameter_type_id=?" ,item.id])
       when AssayParameter then  find(:all,:conditions=>["#{template}.assay_parameter_id=?",item.id])
       when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?"    ,item.id])
       when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?"      ,item.id])
       when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?"   ,item.id])
       when AssayQueue     then  find(:all,:conditions=>["#{template}.assay_queue_id=?"    ,item.id])
       else         
         find(:all,:conditions=>['name like ?',item.to_s])
       end  
     end                  
  end
  ##
  # List of a types
  has_many :types, :class_name =>'ParameterType', :through => :parameters ,:uniq=>true
  #
  # Assay Parameter linked to this role
  #
  has_many :assay_parameters, :dependent => :destroy do
     #
     # Limit set to contexts using the the a object
     #
     def using(item,in_use=false)
       template = 'assay_parameters'
       if in_use
         template = "exists (select 1 from parameters where assay_parameters.id = parameters.assay_parameter_id) and #{template}"
       end
       case item
       when ParameterType  then  find(:all,:conditions=>["#{template}.parameter_type_id=?" ,item.id])
       when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?"    ,item.id])
       when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?"      ,item.id])
       when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?"   ,item.id])
       else         
         find(:all,:conditions=>['name like ?',item.to_s])
       end  
     end                  
  end
    
  def self.find_all_used
    self.find(:all,:conditions=>'exists (select 1 from parameters where parameters.parameter_role_id=parameter_roles.id)')
  end    

#
# Test Whether this is in used in the database
#  
  def used?
    return (assay_parameters.size > 0 or  parameters.size>0)
  end 
  
  def path(scope=nil)
    name
  end
end
