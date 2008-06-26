# == Schema Information
# Schema version: 306
#
# Table name: task_values
#
#  id                 :integer(11)   not null, primary key
#  task_context_id    :integer(11)   not null
#  parameter_id       :integer(11)   not null
#  data_value         :float         not null
#  display_unit       :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  task_id            :integer(11)   not null
#  storage_unit       :string(255)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
###
# This is the key numeric facts table for data capture in the sustem.  basically 
# one row is created here for each value cell filled in ok the data entry grid.
# 
#  This will be the basic source for most ETL work to move data to warehouses
#  and marts. There are a numbere task_results% and %statistics% views already
#  built out of it in the system
#
class TaskValue < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
##
# This add all the common functions for TaskItem
  acts_as_task_item
##
# this work dimension of the value and contains information on when the data
# was captured, its validation status, experiment and assay . All values must 
# linked to a task  
  validates_presence_of :task
##
# As you may guess this defines the context the value is gathered. In simple terms
# the row it was enteried on. 
  validates_presence_of :context
##
# Well we not a ERL so insist on knowing having a parameter to descibe the data
  validates_presence_of :parameter
##
# Well must have a value to be a  good record  
  validates_presence_of :data_value
##
# The task this context belongs too
 belongs_to :task
##
# context is provides a logical grouping of TaskItems which need to be seen as a whole to get the true
# meaning of the data (eg. Inhib+Dose+Sample is useful result!)
 belongs_to :context, :class_name=>'TaskContext', :foreign_key =>'task_context_id'
##
# The parameter definition the Item is linked back to from the Process Instance
# Added IC50(Output) etc to the basic value and defines the validation rules like must be numeric!
#  
 belongs_to :parameter
 
 ##
 # For generic use all TaskItem proviide get and set of a value.
 def value=(new_value)  
   @quantity = self.parameter.parse(new_value)
   if @quantity.is_a?(Unit)
      logger.info "value with unit= #{@quantity}  #{parameter.display_unit} => #{@quantity.to_base.units}"
      self.data_value  = @quantity.to_base.scalar
      self.storage_unit =@quantity.to_base.units
      self.display_unit =@quantity.units     
   else   
      logger.info "value no unit= #{@quantity}"
      self.data_value  = @quantity 
      self.storage_unit =""
      self.display_unit =""
   end
 end 
 #
 # Get the value, should return a Quantity with a unit for use in calculations
 #
 def value
   return self.to_unit
 end  
 #
 # Convert the value to a unit for use is calculations
 #
 def to_unit
    return @quantity if @quantity
    @quantity = Unit.new(self.data_value,self.storage_unit)
    @quantity = @quantity.to(self.display_unit||"") unless @quantity.units ==self.display_unit || self.display_unit=="" || self.display_unit.nil?  
    return @quantity
 end
 #
 # Convert to a string with a unit postfix is a custom unit (display_unit !=parameter.display_unit) has been used.
 # This uses the formating rules defined in the data_format to govern how the output looks
 #
 def to_s
    if self.parameter
      return self.parameter.default_value.to_s unless self.data_value
      self.parameter.format(self.to_unit) 
    else  
      self.data_value.to_s
    end
  end
 
end
