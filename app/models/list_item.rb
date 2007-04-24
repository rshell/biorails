# == Schema Information
# Schema version: 239
#
# Table name: list_items
#
#  id        :integer(11)   not null, primary key
#  list_id   :integer(11)   
#  data_type :string(255)   
#  data_id   :integer(11)   
#  data_name :string(255)   
#

class ListItem < ActiveRecord::Base
  include CatalogueReference

  belongs_to :list

  validates_presence_of :list
  validates_presence_of :data_type
  validates_presence_of :data_id
  validates_presence_of :data_name

  def data_element
    list.data_element
  end  

end
