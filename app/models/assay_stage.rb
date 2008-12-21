# == Schema Information
# Schema version: 359
#
# Table name: assay_stages
#
#  id                 :integer(4)      not null, primary key
#  name               :string(128)     default(""), not null
#  description        :string(1024)    default(""), not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# Simple internal dictionary of Stages within a assay. These are used to partition
# protocols and provide a general cascade in the reporting views.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class AssayStage < ActiveRecord::Base
  
   acts_as_dictionary :name 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name
  has_many :protocols, :class_name =>'AssayProtocol', :dependent => :nullify
end
