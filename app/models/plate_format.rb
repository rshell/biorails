# == Schema Information
# Schema version: 233
#
# Table name: plate_formats
#
#  id           :integer(11)   not null, primary key
#  name         :string(128)   default(), not null
#  description  :text          
#  rows         :integer(11)   
#  columns      :integer(11)   
#  lock_version :integer(11)   default(0), not null
#  created_by   :string(32)    default(), not null
#  created_at   :datetime      not null
#  updated_by   :string(32)    default(), not null
#  updated_at   :datetime      not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class PlateFormat < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  has_many :containers

  has_many :wells , :class_name => "PlateWell",:order =>'slot_no, row_no, column_no'
  
end
