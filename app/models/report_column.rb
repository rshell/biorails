# == Schema Information
# Schema version: 359
#
# Table name: report_columns
#
#  id                 :integer(4)      not null, primary key
#  report_id          :integer(4)      not null
#  name               :string(128)     default(""), not null
#  description        :string(1024)    default("")
#  join_model         :string(255)
#  label              :string(255)
#  action             :string(255)
#  filter_operation   :string(255)
#  filter_text        :string(255)
#  subject_type       :string(255)
#  subject_id         :integer(4)
#  data_element       :integer(4)
#  is_visible         :boolean(1)      default(TRUE)
#  is_filterible      :boolean(1)      default(TRUE)
#  is_sortable        :boolean(1)      default(TRUE)
#  order_num          :integer(4)
#  sort_num           :integer(4)
#  sort_direction     :string(11)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  join_name          :string(255)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# This is the display rules for a column in a report
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ReportColumn < ActiveRecord::Base

  belongs_to :report
  belongs_to :filter, :polymorphic => true
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

##
# Simgle helper call to customize a columns property
#
#
  def customize(params={})
    logger.info(params.to_xml)
    logger.info "old ReportColumn.customize Id:#{id} Label:#{label} show:#{is_visible} order:#{order_num} sort:#{is_sortable} sort_n:#{sort_num} sort_dir:#{sort_direction} filterable:#{is_filterible} filter:#{filter}"
      params.map do |key,item|
        logger.debug " #{key}=#{item}"
        case key.to_sym
        when :is_visible      
          logger.debug "old value #{is_visible}"
           self.is_visible= ['1','true','Y','y',true].include?(item.to_s)
          logger.debug "new value #{is_visible}"
        when :label           then  self.label= item.to_s      
        when :order_num       then  self.order_num= item.to_i
        when :is_filterible,:is_filterable   then  self.is_filterible = ['1','true','Y','y',true].include?(item.to_s)
        when :filter          then  self.filter = item.to_s
        when :action          then  self.action = item
        when :is_sortable     then  self.is_sortable =  ['1','true','Y','y',true].include?(item.to_s)
        when :sort_direction 
          if ['asc','desc'].include?(item)
                self.sort_direction = item
                self.sort_num ||= params[:sort_num].to_i || self.order_num+1
            else   
                self.sort_direction = nil
                self.sort_num = nil
            end   
        end
    end 
    logger.info "new ReportColumn.customize Id:#{id} Label:#{label} show:#{is_visible} order:#{order_num} sort:#{is_sortable} sort_n:#{sort_num} sort_dir:#{sort_direction} filterable:#{is_filterible} filter:#{filter}"
    self.save
  end
  
##
# Get the name as a table attribute pair 
# 
# @todo Need to work on how to handle same table appearing multiple times.
# 
  def table_attribute
    attribute = self.name.split(".").pop
    if  join_model
       logger.info " #{report.model.reflections[join_model.to_sym].class_name}"
       return report.model.reflections[join_model.to_sym].class_name.tableize.to_s + "." + attribute.to_s
    else
       return report.model.class_name.tableize.to_s + "." + attribute.to_s
    end
  end

  def has_many?
   self.join_name=="has_many"
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
  #
  # Format values for the column based on default rules for data types
  #
  def format(value)
     case value 
     when NilClass
         '<null>'         
     when Date
       value.strftime("%Y-%b-%d")
     when DateTime
       value.strftime("%Y-%b-%d")
     when Time
       value.strftime("%Y-%b-%d")
     when Numeric
         if value.abs > 0.01
           sprintf("%9.2f", value).to_s
         else
           sprintf("%9.4g", value).to_s
         end
     else 
         value.to_s 
     end
  end

##
# The the value for display for the row/column. As this may be on another object
# follow the the dot separated path in the name (eg object.object.method) to the end.
# In the case of has_many relation a array of values is returned
# 
  def value(row)
    elements = name.split(".").reverse
    @value = values(row,elements)
  rescue Exception => ex
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
# a has_Reportmany relationship this may lead down a whole tree. This can result in a large
# nested tree of of values where links are arrays. 
# eg. row.experiments.tasks.name -> [[a,b,c],[e,f,g]]
# 
#   
  def values(data_row,elements) 
    out = []
    while elements.size>0 and !data_row.nil? do
      data_row = data_row.send(elements.pop)        
      if data_row.class == Array
        for item in data_row
           out << values(item, elements.clone)
        end 
        return out
      end 
     end  
     return data_row
  rescue Exception => ex
      logger.error ex.message
      logger.debug ex.backtrace.join("\n")    
      "#Error"
  end
  

##
# Set the filter to apply to the current column
# This scans for a starting operator =, > or < then scans
# the string for a '%' or '?' in string to set a like operator
#
  def filter= (value)
    logger.debug "filter= #{value}"
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
    when /^in/,/^IN/ 
       self.filter_operation = "in"
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
    when 'in'
      "#{self.filter_text}"
    when '=','like'
      self.filter_text
    else
      "#{self.filter_operation}#{self.filter_text}"
    end
  end

  def to_ext
    item = {
       :id => self.id,
      :name => self.name,
      :label => self.label,
      :filter => self.filter,
      :is_filterible => self.is_filterible,
      :is_visible => self.is_visible, 
      :is_sortable => self.is_sortable,
      :sort_num => self.sort_num || 0,
      :sort_direction =>  self.sort_direction
    }
  end
  
end
