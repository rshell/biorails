# == Schema Information
# Schema version: 359
#
# Table name: cross_tab_filters
#
#  id                  :integer(4)      not null, primary key
#  cross_tab_id        :integer(4)      not null
#  filter_op           :string(255)
#  filter_text         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  session_name        :string(255)     default("default")
#  cross_tab_column_id :integer(4)
#

# == Description
# Rule for a filter in a report
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
#
class CrossTabFilter < ActiveRecord::Base
  
  belongs_to :cross_tab, :class_name=>'CrossTab'  
  belongs_to :column, :foreign_key=>'cross_tab_column_id',:class_name=>'CrossTabColumn'
  validates_presence_of :cross_tab_id  
  validates_presence_of :cross_tab_column_id  
  validates_presence_of :filter_op
  validates_presence_of :filter_text

  # 
  # Generate exists (xxx) SQL rule for inclusion of rows in the results set
  # 
  def exists_rule
    case column.data_type_id
    when 2
      cond = <<SQL
 exists ( select 1 from task_values  where task_values.parameter_id =#{column.parameter_id} 
 and task_values.task_context_id = task_contexts.id and task_values.#{numeric_filter_rule('data_value')} )  
SQL
    when 5
      cond = <<SQL
 exists ( select 1 from task_references  where task_references.parameter_id =#{column.parameter_id}  
 and task_references.task_context_id = task_contexts.id and task_references.#{default_filter_rule('data_name')} )  
SQL
    else  
      cond = <<SQL
 exists ( select 1 from task_texts where task_texts.parameter_id =#{column.parameter_id}   
 and task_texts.task_context_id = task_contexts.id and task_texts.#{default_filter_rule('data_content')} )  
SQL
    end     
    return cond
  end

   
  def quantity
    @quantity ||= column.parameter.parse(filter_text)
  end
  
  def unit?
    not column.parameter.display_unit.blank?
  end

  def unit
    quantity.to_base.units
  rescue
    column.parameter.display_unit
  end
  
  # 
  # Value convert to correct base for numeric values
  # 
  def value
    if quantity.is_a?(Unit)
      quantity.to_base.scalar
    else
      filter_text
    end
  end

  def numeric_filter_rule(field)
    return default_filter_rule(field) unless  unit?
    item = case filter_op
            when '='        then "#{field} = '#{value}' "
            when '>'        then "#{field} > '#{value}' "
            when '<'        then "#{field} < '#{value}' "
            when 'between'  then "#{field} between '#{filter_text}' and '#{value_high}'"
            when 'like'     then "#{field} like '#{filter_text}'"
            when 'starting' then "#{field} like '#{filter_text}%'"
            when 'ending'   then "#{field} like '%#{filter_text}'"
            when 'contains' then "#{field} like '%#{filter_text}%'"
            else
              logger.warn "Invalid operator #{filter_op}"
              "#{field} is not null"
    end
    item << " and storage_unit = '#{unit}' " unless unit.blank?
    return item
  end
  
  def default_filter_rule(field)
    case filter_op
    when '='        then "#{field} = '#{filter_text}'"
    when '>'        then "#{field} > '#{filter_text}'"
    when '<'        then "#{field} < '#{filter_text}'"
    when 'between'  then "#{field} between '#{filter_text}' and '#{value_high}'"
    when 'like'     then "#{field} like '#{filter_text}'"
    when 'starting' then "#{field} like '#{filter_text}%'"
    when 'ending'   then "#{field} like '%#{filter_text}'"
    when 'contains' then "#{field} like '%#{filter_text}%'"
    else
      logger.warn "Invalid operator #{filter_op}"
      "#{field} is not null"
    end
  end  
    
end
