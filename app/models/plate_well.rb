# == Schema Information
# Schema version: 233
#
# Table name: plate_wells
#
#  id           :integer(11)   not null, primary key
#  name         :string(128)   default(), not null
#  label        :string(255)   
#  row_no       :integer(11)   default(0), not null
#  column_no    :integer(11)   default(0), not null
#  slot_no      :integer(11)   default(0), not null
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

class PlateWell < ActiveRecord::Base

  belongs_to :plate_format
  
end
