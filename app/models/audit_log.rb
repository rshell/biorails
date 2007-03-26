# == Schema Information
# Schema version: 123
#
# Table name: audit_logs
#
#  id             :integer(11)   not null, primary key
#  auditable_id   :integer(11)   
#  auditable_type :string(255)   
#  user_id        :integer(11)   
#  action         :string(255)   
#  changes        :text          
#  created_by     :string(255)   
#  created_at     :datetime      
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class AuditLog < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  
  serialize :changes
  
  cattr_accessor :audited_classes
  self.audited_classes = []
end
