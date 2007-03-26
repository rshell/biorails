# == Schema Information
# Schema version: 123
#
# Table name: reports
#
#  id           :integer(11)   not null, primary key
#  name         :string(128)   default(), not null
#  description  :text          
#  base_model   :string(255)   
#  custom_sql   :string(255)   
#  lock_version :integer(11)   default(0), not null
#  created_by   :string(32)    default(), not null
#  created_at   :datetime      not null
#  updated_by   :string(32)    default(), not null
#  updated_at   :datetime      not null
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Report < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  
  validates_uniqueness_of :name
  has_many :columns, :class_name=>'ReportColumn'
  attr_accessor :default_action
  attr_accessor :params
  attr_accessor :decimal_places
  

##
# List of unique join paths for columns in the report
# 
 def joins
    self.columns.collect{|column|column.join_model}.compact.uniq
 end

 def params
   @params ||= {}
 end
 
##
# get the action associated with the row
# 
 def action(row)
   if @default_action
      @default_action.cell(row)
   else 
      nil   
   end
 end

##
# Get the number of elements for each column in the table as a array
# 
  def sizes(row)
     columns.reject{|c|c.join_model.nil?}.collect{|column|column.size(row)}
  end

##
#get a named column
#
 def column(name)
    column = columns.detect{|col|col.name == name}
    column ||= add_column(name)
    return column
 end

##
# Add a column to a report based on a dot separated path name.
# eg. experiment.study.name this allow for the fun of trees of values
# 
# 
 def add_column(column_name,params={})
    column = ReportColumn.new(:report=> self,
                              :is_filterible =>  false, 
                              :is_sortable => true,
                              :order_num=> self.columns.size,
                              :is_visible => !(column_name =~ /(lock_version|_by|_at|_id|_count)$/ ) 
     )
    column.name = column_name
    column.customize(params)
    self.columns << column
    return column
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end

 
 def decimal_places
   @decimal_places ||= 3
 end

##
# Set the base model for the report. Only if there are not columns defined 
# and no existing model 
#
 def model= (value)
   unless @model
     @model = value
     self.name = "new #{@model.to_s}"
     self.description = "new #{@model.to_s} report"
     self.base_model = @model.to_s
     for col in @model.content_columns
        add_column(col.name)
     end
   else
     logger.warn("cant change the model of a report once set")
   end
   @params = {}
   @params[:controller]=value.to_s.tableize
   @params[:action]='show'
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end

##
# get the current model
# 
 def model
   @model ||= eval(base_model) if base_model
 end
 

  
##
# Apply the name=value hash of filter values to the query. This applies these the the
# named columns as a set of conbined filters on the returned data.
# As a general rule values are scanned for special characters to set the filter operation
# like %,>,< for operations like,greater then,less then.
# 
# eg. set_filter({:name => 'Fred%',:user =>'rshell'})
# 
 def set_filter(params={})
    params.each do  | key,value |
        column(key.to_s).filter = value unless value.nil? or value.size==0
    end
 end
 
##
# adds columns to the sort order for the columns in the report.
# Existing sorted columns are keeped as futher classification eg.
#
# add_sort('name') --> name asc
# add_sort('user desc') --> user desc,name asc
#  
 def add_sort(sort_list)
    params = sort_list.split(",").reverse
    for item in params
      sort_columns.each{|c|c.sort_num += 1}
      c = column( item.split(":")[0])
      c.sort_num = 1
      c.sort_direction = item.split(":")[1]||'asc'
    end
 end

##
# Get the current sort key of the query
# returns a array of columns used to sort the data in order they are applied
# 
#  
def sort_columns
   return self.columns.reject{|column|column.sort_num.nil?}.sort{|a,b| a.sort_num <=> b.sort_num}
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
end

##
# Get a list of active filter columns in the report. Based on whether there is a filter_text
# value in column
# 
def filter_columns
   return self.columns.reject{|column|column.filter_operation.nil?}
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
end

##
# Get a sorted list of all the columns in the query
# 
 def displayed_columns 
    return self.columns.reject{|column|!column.is_visible}.sort{|a,b| a.order_num <=> b.order_num}
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")  
      return  self.columns 
 end

##
# Get a list of the joins to base view
# 
# @todo Currently only supports single level of joins to base table
# 
 def joins  
  self.columns.collect{|column|column.join}.compact.uniq
 end

##
# output a list of model links to include in find method
# 
 def includes
   out = []
   for item in joins
     if item[1]
     out << item[0] unless item[1].macro==:has_many
     end
   end
   if out.size>0
     out
   else 
     nil
   end
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end
 
##
#Execute the Query Applying all the filter and sort rules for the columns 
#
 def run( params= {})
   @model = self.model
   if @model
     params = params.merge({:conditions => conditions, :order => order, :include => includes })
     return @model.find(:all, params ) 
   end  
 end 

##
# 
 def order
   sort = sort_columns
   if sort == []
      return nil 
   else
      return sort.collect{|column|"#{column.table_attribute} #{column.sort_direction.to_s}"}.join(",")
   end
 end

##
# Get the current conditions for the query
#  
 def conditions
   cond = []
   values =[]
   for column in filter_columns
     case column.filter_operation.to_s
     when 'in'
       cond << "#{column.table_attribute} #{column.filter_operation} #{column.filter_text}"
     when 'not in'
       cond << "#{column.table_attribute} #{column.filter_operation} #{column.filter_text}"
     when 'exists'
       cond << "#{column.table_attribute} #{column.filter_operation} #{column.filter_text}"
     when 'not exists'
       cond << "#{column.table_attribute} #{column.filter_operation} #{column.filter_text}"
     else
       cond << " #{column.table_attribute} #{column.filter_operation} ? "
       values <<  column.filter_text 
     end
   end
   if cond.size==0
     return nil 
   else
     filter = []
     filter << cond.join(" and ")
     filter.concat(values)
     return filter.flatten 
   end
 end

end
