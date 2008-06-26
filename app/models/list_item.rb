# == Schema Information
# Schema version: 306
#
# Table name: list_items
#
#  id        :integer(11)   not null, primary key
#  list_id   :integer(11)   not null
#  data_type :string(255)   
#  data_id   :integer(11)   
#  data_name :string(255)   
#

class ListItem < ActiveRecord::Base

  acts_as_catalogue_reference

  belongs_to :list

  validates_presence_of :list_id
  validates_presence_of :data_type
  validates_presence_of :data_id
  validates_presence_of :data_name
  validates_uniqueness_of :data_id, :scope=>:list_id

  def data_element
    list.data_element
  end  

end
