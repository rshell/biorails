# == Schema Information
# Schema version: 359
#
# Table name: task_references
#
#  id                 :integer(4)      not null, primary key
#  task_context_id    :integer(4)      not null
#  parameter_id       :integer(4)      not null
#  data_element_id    :integer(4)
#  data_type          :string(255)     not null
#  data_id            :integer(4)      not null
#  data_name          :string(255)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  task_id            :integer(4)      not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
#
# This is used for references to objects in this or other schema. Basically links back to ideas
# of catalogue and data element values. It stores the DataElement plus Class,Id,name for the value
#  
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class TaskReference < ActiveRecord::Base

  acts_as_task_item

  acts_as_catalogue_reference

##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log, :auditing_enabled =>true

  
  validates_presence_of :task
  validates_presence_of :context
  validates_presence_of :parameter
  
  validates_presence_of :data_type
  validates_presence_of :data_id
  validates_presence_of :data_name

##
# The task this context belongs too
  belongs_to :task

##
# Special polymorphic link back to reference subject
# replace with more reflexable systems as may link to other databases !
# belongs_to :type, :polymorphic => true

##
# context is provides a logical grouping of TaskItems which need to be seen as a whole to get the true
# meaning of the data (eg. Inhib+Dose+Sample is useful result!)
 belongs_to :context, :class_name=>'TaskContext',:foreign_key =>'task_context_id'

##
# The parameter definition the Item is linked back to from the Process Instance
# Added IC50(Output) etc to the basic value and defines the validation rules like must be numeric!
#  
 belongs_to :parameter

##
# get the underlying data_element. Currently removed from TaskReference as a normallization of model
# 
 def data_element
   parameter.data_element
 end

 def to_unit
   Unit.new(data_name.to_s) 
 rescue 
    nil
 end
 
 def to_s
   return self.parameter.default_value.to_s unless self.data_id
   "#{self.data_name}"
 end

end
