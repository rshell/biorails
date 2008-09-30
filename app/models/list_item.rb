# == Schema Information
# Schema version: 359
#
# Table name: list_items
#
#  id        :integer(4)      not null, primary key
#  list_id   :integer(4)      not null
#  data_type :string(255)
#  data_id   :integer(4)
#  data_name :string(255)
#

# == Description
# Base Class for external analysis
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ListItem < ActiveRecord::Base

  acts_as_catalogue_reference

  belongs_to :list

  validates_presence_of :list_id
  validates_presence_of :data_type
  validates_presence_of :data_id
  validates_presence_of :data_name
  validates_uniqueness_of :data_id, :scope=>:list_id
  #
  # Data Element Type for the list element.
  #
  def data_element
    list.data_element
  end  

end
