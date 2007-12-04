# == Schema Information
# Schema version: 281
#
# Table name: plate_wells
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  label              :string(255)   
#  row_no             :integer(11)   default(0), not null
#  column_no          :integer(11)   default(0), not null
#  slot_no            :integer(11)   default(0), not null
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class PlateWell < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

  belongs_to :plate_format
  
end
