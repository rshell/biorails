# == Schema Information
# Schema version: 123
#
# Table name: markup_styles
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   default(), not null
#

class MarkupStyle < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
end
