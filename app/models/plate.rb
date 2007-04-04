# == Schema Information
# Schema version: 233
#
# Table name: plates
#
#  id             :integer(11)   not null, primary key
#  name           :string(255)   
#  description    :text          
#  external_ref   :string(255)   
#  quantity_unit  :string(255)   
#  quantity_value :float         
#  url            :string(255)   
#  lock_version   :integer(11)   default(0), not null
#  created_by     :string(32)    default(sys), not null
#  created_at     :datetime      not null
#  updated_by     :string(32)    default(sys), not null
#  updated_at     :datetime      not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#

require 'ajax_scaffold'

class Plate < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  
end
