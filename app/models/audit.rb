# == Schema Information
# Schema version: 359
#
# Table name: audits
#
#  id             :integer(4)      not null, primary key
#  auditable_id   :integer(4)
#  auditable_type :string(255)
#  user_id        :integer(4)
#  user_type      :string(255)
#  session_id     :string(255)
#  action         :string(255)
#  changes        :text
#  created_at     :datetime
#

# == Description
# Base Audit class this is linked to all classes using the acts_as_audited meta method. 
# the auditiable polymorphic reference links back to the orginal object.
# The changes properties contains encoded old and new values for the object
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Audit < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  
  serialize :changes
  
  cattr_accessor :audited_classes
  self.audited_classes = []
  
end
