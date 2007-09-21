# == Schema Information
# Schema version: 280
#
# Table name: parameter_roles
#
#  id                 :integer(11)   not null, primary key
#  name               :string(50)    default(), not null
#  description        :string(255)   default(), not null
#  weighing           :integer(11)   default(0), not null
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

class ParameterRole < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name

##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

  has_many :parameters, :dependent => :destroy
  has_many :study_parameters, :dependent => :destroy

end
