# == Schema Information
# Schema version: 123
#
# Table name: work_status
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  description  :string(255)   
#  lock_version :integer(11)   default(0), not null
#  created_by   :string(32)    default(), not null
#  created_at   :datetime      not null
#  updated_by   :string(32)    default(), not null
#  updated_at   :datetime      not null
#

##
#Simple Lookup of Status Values for experiments and tasks.
#
###
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Status < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  set_table_name :work_status
end
