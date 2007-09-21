# == Schema Information
# Schema version: 280
#
# Table name: reports
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :text          
#  base_model         :string(255)   
#  custom_sql         :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  style              :string(255)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#  internal           :boolean(1)    
#  project_id         :integer(11)   
#  action             :string(255)   
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Report < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>"internal"
  validates_presence_of :name
  validates_presence_of :description

  has_many :columns, :class_name=>'ReportColumn', :order=>'order_num,name', :dependent => :destroy 

  belongs_to :project

  attr_accessor :default_action
  attr_accessor :params
  attr_accessor :decimal_places
  
 def params
   @params ||= {}
 end

##
# setup defaults for sorts and filter over all the columns
#  
 def refresh(defaults)
   set_filter(defaults[:filter])if  defaults[:filter] 
   add_sort(defaults[:sort]) if defaults[:sort]
 end

#
# List all reporting containing this model name. This will search for by base_model 
# and report_columns join_model to find matches.
# 
 def self.contains_column(column)
    sql ="select r.* from reports r where exists (select 1 from report_columns c where c.report_id = r.id and c.name=?)"
    list = Report.find_by_sql([sql,"#{column}"])
    logger.debug("Reports.containing#{column})==> list of #{list.size}")
    return list
 end
#
# Get the number of elements for each column in the table as a array
# 
  def sizes(row)
     columns.reject{|c|c.join_model.nil?}.collect{|column|column.size(row)}
  end
#
# test if this has a column
#
 def has_column?(name)
    column = columns.detect{|col|col.name == name}
 end
#
#get a named column
#
 def column(name)
    column = has_column?(name)
    column ||= add_column(name)
    return column
 end
#
# Add a column to a report based on a dot separated path name.
# eg. experiment.study.name this allow for the fun of trees of values
# 
 def add_column(column_name,params={})
    column = ReportColumn.new(:report=> self,
                              :is_filterible =>  false, 
                              :is_sortable => true,
                              :order_num=> self.columns.size,
                              :is_visible => !(column_name =~ /(lock_version|_by|_at|_id|_count)$/ ) 
     )
    column.name = column_name
    column.label = column_name.split('.').collect{|c|c.capitalize}.join(' ')
    column.is_visible =  !(column_name =~ /(lock_version|_by|_at|_id|_count)$/ ) 
    route = column_name.split(".")
    if route.size>1 
       logger.debug "add_column route= #{route[0]}"
       join = self.model.reflections[route[0].to_sym]
       if join
           column.join_model = route[0]
           column.join_name = join.macro.to_s
           if join.macro == :has_many
             column.is_filterible = false
             column.is_sortable = false
           end
       end
         
    else
       column.join_model = nil
    end
    self.columns << column
    return column

 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end
#
# Number of decimal places to display
#
 def decimal_places
   @decimal_places ||= 3
 end
##
# Create a report from a model 
# 
 def Report.for_model(model,options={})
     report = Report.new(options)
     report.name        = Identifier.next_id(Report)
     report.description = "new #{model.to_s} based report"
     report.base_model = model.to_s
     report.model = model
     report.save
     for col in model.content_columns
        report.add_column(col.name)
     end
     return report
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end
#
# Set the base model for the report. Only if there are not columns defined 
# and no existing model 
#
 def model= (value)
   unless @model
     @model = value
     self.base_model = @model.to_s
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
#
# get the current model
# 
 def model
   @model ||= eval(base_model) if base_model
 end
#
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
#
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
      c.sort_direction = item.split(":")[1]||c.next_direction
    end
 end
#
# Get the current sort key of the query
# returns a array of columns used to sort the data in order they are applied
#  
def sort_columns
   return self.columns.reject{|column|column.sort_num.nil?}.sort{|a,b| a.sort_num <=> b.sort_num}
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
end
#
# Get a list of active filter columns in the report. Based on whether there is a filter_text
# value in column
# 
def filter_columns
   return self.columns.reject{|column|column.filter_operation.nil?}
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
end
#
# Get a sorted list of all the columns in the query
# 
 def displayed_columns 
    return self.columns.reject{|column|!column.is_visible}.sort{|a,b| a.order_num <=> b.order_num}
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")  
      return  self.columns 
 end
#
# output a list of model links to include in find method
# 
 def includes
   out = []
   for item in  self.columns
     unless  item.join_model.nil?
        out << item.join_model unless item.join_name=="has_many"
     end
   end
   if out.size>0
     out.uniq
   else 
     nil
   end
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end
#
# order clause for report
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
# Get the maximum depth of nested tables 
# 
 def max_depth
   return columns.collect{|c|c.name.split(".").size}.max
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
#
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
# Default report to build if none found in library
#    
  def self.internal_report( name, model, &block)
    name ||= "Biorails::List #{model}"
    Report.transaction do
      report = Report.find(:first,:conditions=>['name=? and base_model=?',name.to_s, model.to_s])
      if report.nil?
          logger.info " Generating default report #{name} for model #{model}"
          report = Report.new
          report.name = name 
          report.description = "Default reports for display as /#{model.to_s}/list"
          report.model= model
          report.internal=true
          report.style ='System'
          report.save
          for col in model.content_columns
            report.column(col.name)
         end          
          report.column('id').is_visible = false
          if report.has_column?('name')
             report.column('name').is_filterible = true
          end
          unless report.save
             logger.warn("failed to save report:"+report.errors.full_messages().join("\n"))
             logger.debug(report.to_yaml)             
          end
      else
          logger.info " Using current report #{name} for model #{model.class}"             
      end #built report
      yield report if block_given?   
      return report
    end # commit transaction
  end

##
# Generate a default report to display all the reports in the list of types
#
  def self.reports_on_models(list,name = nil)
   list = list.collect{|i|i.to_s}
   name ||= "List_for_#{list.join('_')}"
   report = Report.find(:first,:conditions=>['name=? and base_model=?',name,'Report'])
   unless report
     report = Report.new
     report.model = Report
     report.name = name
     report.description = "#{name} list of all #{list.join(',')} based reports on the system"
     report.column('custom_sql').is_visible=false
     report.column('id').is_visible = false
     column = report.column('base_model')
     column.filter_operation = 'in'
     column.filter_text = "("+list.join(",")+")"
     column.is_filterible = false
     report.save
   end
   return report
  end


end

