# == Schema Information
# Schema version: 359
#
# Table name: cross_tab_columns
#
#  id                 :integer(4)      not null, primary key
#  cross_tab_id       :integer(4)      not null
#  name               :string(64)
#  title              :string(64)
#  parameter_id       :integer(4)
#  assay_parameter_id :integer(4)
#  parameter_type_id  :integer(4)      not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime
#  created_by_user_id :integer(4)      default(1), not null
#  updated_at         :datetime
#  updated_by_user_id :integer(4)      default(1), not null
#

# == Description
# Rules for use of a column in a report
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class CrossTabColumn < ActiveRecord::Base

  belongs_to :cross_tab, :class_name=>'CrossTab'
  
  belongs_to :assay_parameter
  belongs_to :parameter
  belongs_to :parameter_type

  validates_presence_of :name
  validates_presence_of :parameter_type_id  
  validates_presence_of :assay_parameter_id  
  validates_uniqueness_of :name,:scope => :cross_tab_id
  validates_uniqueness_of :parameter_id,:scope => :cross_tab_id
  
  
  def initialize(options={})
    super(options)
    self.assay_parameter_id = self.parameter.assay_parameter_id if self.parameter_id
    self.parameter_type_id |= self.assay_parameter.parameter_type_id if self.assay_parameter_id
  end  
  #
  # Set parameter and update linked fields
  #
  def parameter=(item)
    self.parameter_id = item.id
    self.assay_parameter_id = item.assay_parameter_id
    self.parameter_type_id = item.parameter_type_id
  end
  #
  # Set the assay_parameter and update the type to match
  #
  def assay_parameter=(item)
    self.assay_parameter_id = item.id
    self.parameter_type_id = item.parameter_type_id
  end  
  #
  # Get the ProtocolVersion via the parameter
  #
  def process
    self.parameter.process  if self.parameter
  end
  #
  # Get the ParameterContext via the parameter
  #
  def parameter_context
    self.parameter.context  if self.parameter
  end
  #
  # Get the ParameterRole via the parameter
  #
  def parameter_role
    self.parameter.role if self.parameter
  end  
  
  def data_type_id
    self.parameter.data_type_id  if self.parameter
  end
  
  #
  # assay for column if linked 
  #
  def assay
    if self.assay_parameter
      return self.assay_parameter.assay
    end
  end
  #
  # Get the operator for this column
  #
  def operator
     filter.filter_op  if filtered?

  end
  #
  # is filtered
  #
  def filtered?
    !self.filter.nil?
  end
  #
  # Filter for the column
  #
  def filter
    @filter ||= CrossTabFilter.find(:first,:conditions=>["cross_tab_id=? and session_name= ? and cross_tab_column_id=?",self.cross_tab_id,'default',self.id])
  end
  #
  # Get the value for this item
  #
  def value
    filter.filter_text  if filtered?
  end
  #
  # Path name for the parameter
  #
  def path
    if self.parameter
      "#{self.assay.name}/#{self.parameter.process.name}/#{self.parameter.name}"   
    else
      "<#{self.name}>"      
    end    
  end
  
end
