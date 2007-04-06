# == Schema Information
# Schema version: 233
#
# Table name: data_types
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  description  :string(255)   
#  value_class  :string(255)   
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

class DataType < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
##
#  In usage a DataType has a collection of DataFormat models which are used
#  to govern data entry. This is basically a managment library of regex masks
#  to in other forms.
#  
  has_many :data_formats, :dependent => :destroy
   
end
