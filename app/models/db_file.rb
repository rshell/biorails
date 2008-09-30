# == Schema Information
# Schema version: 359
#
# Table name: db_files
#
#  id   :integer(4)      not null, primary key
#  data :binary(21474836
#

# == Description
# Storage table for files in blobs to separate from other content where needed
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
class DbFile < ActiveRecord::Base

end
