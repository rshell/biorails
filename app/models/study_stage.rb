# == Schema Information
# Schema version: 123
#
# Table name: study_stages
#
#  id           :integer(11)   not null, primary key
#  name         :string(128)   default(), not null
#  description  :text          
#  lock_version :integer(11)   default(0), not null
#  created_by   :string(32)    default(), not null
#  created_at   :datetime      not null
#  updated_by   :string(32)    default(), not null
#  updated_at   :datetime      not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
# Simple internal dictionary of Stages within a study. These are used to partition
# protocols and provide a general cascade in the reporting views.
# 
class StudyStage < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name

end
