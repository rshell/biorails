# == Schema Information
# Schema version: 280
#
# Table name: task_contexts
#
#  id                   :integer(11)   not null, primary key
#  task_id              :integer(11)   
#  parameter_context_id :integer(11)   
#  label                :string(255)   
#  is_valid             :boolean(1)    
#  row_no               :integer(11)   not null
#  parent_id            :integer(11)   
#  sequence_no          :integer(11)   not null
#

# == Schema Information
# Schema version: 233
#
# Table name: task_contexts
#
#  id                   :integer(11)   not null, primary key
#  task_id              :integer(11)   
#  parameter_context_id :integer(11)   
#  label                :string(255)   
#  is_valid             :boolean(1)    
#  row_no               :integer(11)   not null
#  parent_id            :integer(11)   
#  sequence_no          :integer(11)   not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
# This is a row in the web based data entry
#
class TaskContext < ActiveRecord::Base

 attr_accessor :columns
#
# Generic rules for a name and description to be present
  validates_presence_of :label
  validates_presence_of :task
  validates_presence_of :definition
  #validates_presence_of :row_no
  validates_presence_of :sequence_no

##
# a context may be linked part of something larger 
# for example well => sample => plate
# 
 acts_as_tree :order => "id"  
 
##
# The task this context belongs too
 belongs_to :task

##
# The parameter context definition which this context is based on. 
#  
 belongs_to :definition , :class_name=>'ParameterContext',:foreign_key =>'parameter_context_id'

##
# In the Process sets of parameters are grouped into a context of usages
# 
 has_many :values, :class_name=>'TaskValue', :dependent => :destroy, :order =>'parameter_id'

 has_many :texts, :class_name=>'TaskText', :dependent => :destroy,:order =>'parameter_id'

 has_many :references, :class_name=>'TaskReference', :dependent => :destroy,:order =>'parameter_id'

##
# combined array of all TaskItems
# 
 def items
    items = Array.new
    items.concat(values)
    items.concat(files)
    items.concat(texts)
    items.concat(references)
 end

#
# path to this context
# 
# myPlate[1]:sample[2]:well[3]
#
  def path
     if parent == nil 
        return label 
     else 
        return parent.path+":"+label
     end 
  end 

  def to_matrix
    self.task.to_matrix(self)
  end

##
# Parameters allowed for this context
# 
 def parameters
    return definition.parameters
 end
 
 def parameter(name)
    return definition.parameter(name)  
 end
 
##
# get existing TaskItem values for the context   
 def item(parameter)
    case parameter.data_type_id
    when 2 
      value = values.find(:conditions=>["parameter_id=?",parameter.id])
    when 5
      value = references.find(:conditions=>["parameter_id=?",parameter.id])
    else
      value = texts.find(:conditions=>["parameter_id=?",parameter.id])
    end 
    return value if value   
    return add_task_item(parameter,nil)
 end
 
 
 def add_task_item(parameter, value)
    case parameter.data_type_id
    when 2 
      item = add_task_value(parameter,value)
    when 5
      item = add_task_reference(parameter,value)
    else
      item = add_task_text(parameter,value)
    end 
    return item
 end

protected
 def add_task_value(parameter,value)
    item = TaskValue.new
    item.context = self
    item.task = self.task 
    item.parameter = parameter
    item.value = value if value 
    return item
 end 

###
# Create a reference base TestItem linked to data_element value
#
 def add_task_reference(parameter,value)
    item = TaskReference.new
    item.context = self
    item.task = self.task 
    item.parameter = parameter
    item.value = value if value 
    return item
 end 

##
# Create a textual TestItem based on ther value passed in
# 
 def add_task_text(parameter,value)
    item = TaskText.new
    item.context = self
    item.task = self.task 
    item.parameter = parameter
    item.data_content = value if value 
    return item
 end 
 
 def to_s
  '['+ self.id.to_s + ']'  + self.path
 end

end
