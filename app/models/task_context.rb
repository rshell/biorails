# == Schema Information
# Schema version: 359
#
# Table name: task_contexts
#
#  id                   :integer(4)      not null, primary key
#  task_id              :integer(4)      not null
#  parameter_context_id :integer(4)      not null
#  label                :string(255)
#  is_valid             :boolean(1)
#  row_no               :integer(4)      not null
#  parent_id            :integer(4)
#  sequence_no          :integer(4)      not null
#  left_limit           :integer(4)      default(1)
#  right_limit          :integer(4)      default(2)
#

# == Description
# This is a row in the web based data entry. A single context is the smallest 
# pick data that makes sense. Normally it would consists oa a number of values
# marking up the subject of and values linked to this subject.
# 
# The context is the object used for addition of new values to database then item
# method returning the new default or entered value for any item in the context.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class TaskContext < ActiveRecord::Base
  # ## Populated in Task controller with current user for the transaction
  # @todo RJS keep a eye on threading models in post 1.2 Rails to make sure this
  # keeps working
  #
  cattr_accessor :current

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
                     :order => 'task_id,left_limit',
                     :scope => :task_id
  
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
 has_many :values, :class_name=>'TaskValue', :dependent => :destroy, :order =>'parameter_id',
   :include => [:parameter=>[:data_format,:data_element]]

 has_many :texts, :class_name=>'TaskText', :dependent => :destroy,:order =>'parameter_id',
   :include => [:parameter=>[:data_format,:data_element]]

 has_many :references, :class_name=>'TaskReference', :dependent => :destroy,:order =>'parameter_id',
   :include => [:parameter=>[:data_format,:data_element]]

  #
  # Find the assay linked here
  #
  def assay
    self.definition.process.protocol.assay
  end
  
  # Get a sequence number of the item based on ancestors in tree 
  # eg. 1 or 1.1.2 etc
  #  
  def seq
    unless self.parent_id
      "#{sequence_no}" 
    else
      "#{self.parent.seq}.#{sequence_no}"
    end
  end
#
# Create a new Context with self as parent
# 
 def add_context(parameter_context = nil, new_label = nil)
     raise("Failed definition invalid for parent") unless parameter_context.parent_id == self.parameter_context_id
     task.add_context(parameter_context,new_label,self)
 end 
 
 def append_copy
   TaskContext.transaction do
     if self.parent_id
       self.parent.add_context(self.definition)
     else
       self.task.add_context(self.definition)     
     end
   end
 end  
 #
 # Add a named parameter
 #
  def add_parameter(object)
   ProtocolVersion.transaction do
     assay_parameter = object
     case object
      when AssayParameter
        assay_parameter = object
      when Parameter
        assay_parameter = object.assay_parameter
      else
        assay_parameter = self.task.process.protocol.assay.parameters.find_by_name(object.to_s)
     end
     if assay_parameter && self.task.flexible?
        self.definition.add_parameter(assay_parameter)                
     end
   end
  end
  #
  # =function(param,param)
  # =parameter.method

  #
  def calculate(formula,value)
   case formula
   when /=(max|min|sum|count)\((.*)\)/
     parameter = task.process.parameter($2)
      list = all_children.collect{|row| row.items.select{|cell| (cell.parameter_id == parameter.id ? cell.value : nil) }}.compact.flatten
      return list.send($1)
   when /=([A-Z,a-z,0-9,_]*)\.(.*)$/
     source = self.item($1)
     if source.is_a?(TaskReference)
       value = source.object.send($2)
     elsif source
       value =  source.value.send($2)
     end
   end
   return value.to_s
  rescue Exception=> ex
    logger.info  "Invalid formula [#{formula}] error: #{ex.message}"
    logger.debug ex.backtrace.join("\n")
    return value
  end
  #
  # test if there is a formula in the cell
  #
  def formula?(text=nil)
    (/=(max|min|sum|count)\(.*\)/ =~ text) or ( /=([A-Z,a-z,0-9,_]*)\.(.*)$/ =~ text)
  end
  #
  # Recalculate values for the row
  #
  def recalculate
    Task.transaction do
      definition.parameters.each do |parameter|
         if formula?(parameter.default_value)
           value = calculate(parameter.default_value,nil)
           set_value(parameter,value.to_s)
         end
      end
    end
  end

  #
  # Set a Value for this task
  #
  def set_value(parameter,value)
    item = {:passed=>value}
    #
    # Abort if should not be editable
    #
    task.start_processing
    unless task.active? 
      item[:errors] = "task is #{task.status} so cannot change values"
      return item
    end
    cell = item(parameter, value )
    #
    # If there a formula apply it
    #
    if formula?(cell.formula)
       value = calculate(cell.formula,value)
    elsif formula?(value)
       value = calculate(value,value)
    end
    #
    # If there is a default apply it
    #
    if cell.new_record?
       value ||= cell.parameter.default_value
    end
    #
    # If empty delete the cell
    #
    if value.blank? or (value==DataElement::BLANK and cell.is_a?(TaskReference))
      item[:value] = ""
      item[:info] = "deleted #{cell.dom_id}"
      cell.destroy
      return item
    end
    #
    # Check it matches the parameters regexp text mask
    #
    unless cell.parameter.parse(value)
       item[:errors] = "Failed validation for #{cell.parameter.style}"
       return item
    end
    #
    # Save the new value if it looks ok
    #
    logger.info "value is now:[[[[[ #{value} ]]]]]"
    cell.value = value.to_s
    if cell.save
      item[:value] = cell.to_s
      item[:data] = self.to_hash
      task.updated_at = cell.updated_at
    else
       item[:errors] = "cant update cell #{cell.errors.full_messages.to_sentence}"
    end
    return item
  rescue Exception => ex
    item[:errors] = "Error #{ex.message} in cell update "
    return item
  end
  #
  # Populate this context creating all child contexts
  #
  def populate
    rows = []
    for context in self.definition.children.sort_by{|i|i.id}
       1.upto(context.default_count) do |n|
         new_label = "#{context.label}.#{self.seq}.#{n}"
         row = self.children.find(:first,:conditions=>['label=?',new_label])
         row ||= self.add_context(context,new_label)         
         rows << row 
         rows << row.populate
       end      
   end
   self.fill_defaults
   return rows
  end  

 def fill_defaults
   self.parameters.each do |param|
     unless param.default_value.blank?
        task_item = self.item(param)
        task_item.save
     end
   end
 end   
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
# get a parameter by from the current parameterContext
#
 def parameter(name)    
    return definition.parameter(name)  
 end

##
# combined array of all TaskItems both real and virtual (empty)
# 
 def items
    unless @items
      @items = Hash.new
      self.values.each{|i| @items[i.parameter_id] = i}
      self.texts.each{|i| @items[i.parameter_id] = i}
      self.references.each{|i| @items[i.parameter_id] = i}
    end
    return @items
 end
 
 #
 # Convert to array of TaskItem
 #
 def to_a
   self.items.values   
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

##
# Get TaskItem value for column the context , by name or parameter
# If no value exists then a parameter will be  
#  item("name") 
#  item(parameter)
#
#
 def item(param,value = nil)   
   param = self.parameter(param) unless param.is_a?(Parameter)
   obj =nil
   case param.data_type_id
   when 2
      obj = self.values.find(:first,:conditions=>['parameter_id=?',param.id])
      obj||= add_task_value(param,value)
   when 5
      obj = self.references.find(:first,:conditions=>['parameter_id=?',param.id])
      obj ||= add_task_reference(param,value)
   else  
      obj = self.texts.find(:first,:conditions=>['parameter_id=?',param.id])
      obj ||= add_task_text(param,value)
   end     
   return obj
 end

 def to_s
  '['+ self.id.to_s + ']'  + self.path
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
    item.value = value unless (value.blank? or value==DataElement::BLANK) 
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
 

end
