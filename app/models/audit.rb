# == Schema Information
# Schema version: 280
#
# Table name: audits
#
#  id             :integer(11)   not null, primary key
#  auditable_id   :integer(11)   
#  auditable_type :string(255)   
#  user_id        :integer(11)   
#  user_type      :string(255)   
#  session_id     :string(255)   
#  action         :string(255)   
#  changes        :text          
#  created_at     :datetime      
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class Audit < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  
  serialize :changes
  
  cattr_accessor :audited_classes
  self.audited_classes = []
  
end
