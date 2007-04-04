# == Schema Information
# Schema version: 233
#
# Table name: data_formats
#
#  id            :integer(11)   not null, primary key
#  name          :string(128)   default(), not null
#  description   :text          
#  default_value :string(255)   
#  format_regex  :string(255)   
#  lock_version  :integer(11)   default(0), not null
#  created_by    :string(32)    default(), not null
#  created_at    :datetime      not null
#  updated_by    :string(32)    default(), not null
#  updated_at    :datetime      not null
#  data_type_id  :integer(11)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class DataFormat < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name

  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|format_regex|_by|_at|_id|_count)$/ || c.name == inheritance_column }
  end

  belongs_to :data_type

end
