# == Schema Information
# Schema version: 123
#
# Table name: report_columns
#
#  id               :integer(11)   not null, primary key
#  report_id        :integer(11)   not null
#  name             :string(128)   default(), not null
#  description      :text          
#  join_model       :string(255)   
#  label            :string(255)   
#  action           :text          
#  filter_operation :string(255)   
#  filter_text      :string(255)   
#  subject_type     :string(255)   
#  subject_id       :integer(11)   
#  data_element     :integer(11)   
#  is_visible       :boolean(1)    default(true)
#  is_filterible    :boolean(1)    default(true)
#  is_sortable      :boolean(1)    default(true)
#  order_num        :integer(11)   
#  sort_num         :integer(11)   
#  sort_direction   :string(11)    
#  lock_version     :integer(11)   default(0), not null
#  created_by       :string(32)    default(), not null
#  created_at       :datetime      not null
#  updated_by       :string(32)    default(), not null
#  updated_at       :datetime      not null
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class ReportColumn < ActiveRecord::Base

  belongs_to :report
  belongs_to :filter, :polymorphic => true

##
# Simgle helper call to customize a columns property
  def customize(params={})
    if params.size>0
      self.is_visible = params[:is_visible]
      self.label = params[:label] if params[:label]
      self.order_num = params[:order_num] || 99 
  
      self.is_filterible =  params[:is_filterible]
      self.filter =  params[:filter] 
      
      self.is_sortable =  params[:is_sortable]
      self.sort_num = params[:sort_num] 
      self.sort_direction = params[:sort_direction]  unless params[:sort_direction].nil?
    end
    logger.debug "ReportColumn.customize #{id} #{label} #{is_visible} #{order_num} #{is_sortable} #{sort_num} #{sort_direction} #{filter}"
  end
  
##
# Created the join path  if needed based on the name 
# 
  def name=(value)
    @attributes['name'] = value
    self.label = value.split('.').collect{|c|c.capitalize}.join(' ')
    self.is_visible =  !(value =~ /(lock_version|_by|_at|_id|_count)$/ ) 
    @route = self.name.split(".")
    if @route.size>1 
       self.join_model = @route[0]
       if has_many
         self.is_filterible = false
         self.is_sortable = false
       end
    else
       self.join_model = nil
    end
  end


##
# if is a has many operation return rthe join otherwize nil
#   
  def has_many
    elements = self.name.split(".")
    return nil if elements.size ==1
    @model = self.report.model
    @join = @model.reflections.find{|key,value| key.to_s == elements[0]}
    return ( (@join and @join[1].macro==:has_many)? @join : nil)
  end
  
##
# Get the name as a table attribute pair 
# 
# @todo Need to work on how to handle same table appearing multiple times.
# 
  def table_attribute
    attribute = self.name.split(".").pop
    return model.table_name.to_s + "." + attribute.to_s
  end

##
# Get the join information for the route link   
# 
  def join
    if self.join_name
       @model = self.report.model
       @model.reflections.find{|key,value| key.to_s == self.join_name}
    else
       nil
    end
  end
##
# model for the attribute 
#    
  def model
    if  self.join_model and route and route.size>0
       @model ||= eval( route[0].class_name )
    end
    @model ||= self.report.model
  end  

  
##
# Returns the route to the column values as a stack to be processed
# as a array of models on the link eg. [Study,StudyParameter,Parameter]
#  
  def route
      return @route if @route 
      @route = []  
      elements = self.name.split(".")
      elements.delete_at(elements.size-1)    
      temp_model = self.report.model        
      for item in elements
           relation = temp_model.reflections[item.to_sym]
           if relation
              temp_model = eval( relation.class_name ) 
              @route << relation
           end
      end 
    return @route
  rescue Exception => ex
      puts ex.message
      puts ex.backtrace.join("\n")       
      @route
  end

##
# Set the next direction for a sort based on current
#    
  def next_direction
     case self.sort_direction
     when 'asc' then 'desc'
     when 'desc' then 'asc'
     else 'asc'
     end
  end
  
##
# Sets a piece of code to fire to process a row to display a value for a column.
#  
  def action(&code)
    self.action = code
  end
##
# The the value for display for the row/column. As this may be on another object
# follow the the dot separated path in the name (eg object.object.method) to the end.
# In the case of has_many relation a array of values is returned
# 
  def value(row)
    elements = name.split(".").reverse
    @value = values(row,elements)
    if self.action 
      self.action.call(row).to_s
    else
      @value
    end    
  rescue Exception => ex
      puts ex.message,self.name,self.action
      logger.error ex.message
      logger.error ex.backtrace.join("\n")  
      return " "  
  end


##
# Get the number of items in cell for details
# 
  def size(row)
    elements = name.split(".").reverse
    @value = values(row,elements)
    if @value.class == Array
      @value.size
    else
      1
    end
  end  
##
# go down the tree of related objects to find the list of matchingb values. In case of 
# a has_many relationship this may lead down a whole tree. This can result in a large
# nested tree of of values where links are arrays. 
# eg. row.experiments.tasks.name -> [[a,b,c],[e,f,g]]
# 
#   
  def values(object,elements) 
    out = []
    while elements.size>0 and !object.nil? do
      object = object.send(elements.pop)        
      if object.class == Array
        for item in object
           out << values(item, elements.clone)
        end 
        return out
      end 
     end  
     return object
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end
  

##
# Set the filter to apply to the current column
# This scans for a starting operator =, > or < then scans
# the string for a '%' or '?' in string to set a like operator
#
  def filter= (value)
    puts "filter= #{value}"
    case value 
    when /^=/
       self.filter_operation = "="
       self.filter_text = value[1..10000] 
    when /^>/
       self.filter_operation = ">"
       self.filter_text = value[1..10000] 
    when /^</
       self.filter_operation = "<"
       self.filter_text = value[1..10000] 
    when /%/
       self.filter_operation = "like"
       self.filter_text = value
    when "" 
       self.filter_operation = nil
       self.filter_text = nil
    when nil 
       self.filter_operation = nil
       self.filter_text = nil
    else 
       self.filter_operation = "="
       self.filter_text = value
    end   
  end

##
# Get the filter to apply to the current column
#   
  def filter
    case self.filter_operation
    when nil
      nil
    when '=','like'
      self.filter_text
    else
      "#{self.filter_operation}#{self.filter_text}"
    end
  end

end
