# == Schema Information
# Schema version: 281
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
#  left_limit           :integer(11)   default(0), not null
#  right_limit          :integer(11)   default(0), not null
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
# Other methods added by acts_as_nested_set are:
# * +root+ - root item of the tree (the one that has a nil parent; should have left_column = 1 too)
# * +roots+ - root items, in case of multiple roots (the ones that have a nil parent)
# * +level+ - number indicating the level, a root being level 0
# * +ancestors+ - array of all parents, with root as first item
# * +self_and_ancestors+ - array of all parents and self
# * +siblings+ - array of all siblings, that are the items sharing the same parent and level
# * +self_and_siblings+ - array of itself and all siblings
# * +count+ - count of all immediate children
# * +children+ - array of all immediate childrens
# * +all_children+ - array of all children and nested children
# * +full_set+ - array of itself and all children and nested children
#
  acts_as_fast_nested_set :parent_column => 'parent_id',
                     :left_column => 'left_limit',
                     :right_column => 'right_limit',
                     :order => 'task_id,left_limit',
                     :scope => :task_id,
                     :text_column => 'label' 
  
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

 
#
# path to this context
# 
# myPlate[1]:sample[2]:well[3]
#
  def path
     if parent.nil? 
        return label 
     else 
        return parent.path+"/"+label
     end 
  end 

  def to_matrix
    self.task.to_matrix(self)
  end
#
# Unique label for the group the row belongs top
#
  def row_group
    unless parent.nil?
        return self.parent.label
    else
      'root'
    end      
  end
##
# Parameters allowed for this context
# 
 def parameters
    return definition.parameters
 end

#
# get a parameter by name
#
 def parameter(name)
    return definition.parameter(name)  
 end

##
# combined array of all TaskItems both real and virtual (empty)
# 
 def items
    @items = Hash.new
    unless @items
      self.values.each{|i| @items[i.name] = i}
      self.texts.each{|i| @items[i.name] = i}
      self.references.each{|i| @items[i.name] = i}
    end
    self.definition.parameters.collect do |p|
      unless @items[p.name]
        @items[p.name] = add_task_item(p)
      end  
    end
    return @items
 end
#
# Generate a hash of the row for external use
#
 def to_hash
   hash = {
           :id => self.id,
           :row_group => self.row_group,
           :row_label => self.label,
           :row_no => self.row_no
           }
   items.values.each do |item|
     hash[item.parameter.dom_id] = item.to_s
   end        
   return hash
 end
#
# Get the value of a named column as a string
#
 def value(name)
    return self.item(name).to_s
 end
 
##
# get TaskItem values for column the context   
 def item(column)
   if column.is_a?(Parameter)
      value = items[column.name] 
      return value if value   
      return add_task_item(column, nil)      
   else   
      value = items[column.to_s]
      return value if value   
      return add_task_item(parameter(column.to_s), nil)      
   end   
 end
 
#
# Create a new task item
#
 def add_task_item(parameter, value  =nil)
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


  # Rebuild all the set based on the parent_id and text_column name
  #
  def self.rebuild_sets
    self.roots.each do |root|
      root.left_limit = 1
      root.right_limit = 2 
      root.save!
      root.rebuild_set
    end
    roots.size
  end
        
  def rebuild_set
    TaskContext.transaction do    
      items = TaskContext.find(:all, :conditions => ["task_id=? AND parent_id = ?",self.task_id, self.id],:order => 'parent_id,id')                                       
      for child in items 
         self.add_child(child)             
      end  
      for child in items 
         child.rebuild_set
      end  
    end
    child_count
 end
 
protected
 def add_task_value(parameter,value  =nil)
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
 def add_task_reference(parameter,value =nil)
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
 def add_task_text(parameter,value  =nil)
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
