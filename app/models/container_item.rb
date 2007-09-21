# == Schema Information
# Schema version: 280
#
# Table name: container_items
#
#  id                 :integer(11)   not null, primary key
#  container_group_id :integer(11)   not null
#  subject_type       :string(255)   default(), not null
#  subject_id         :integer(11)   not null
#  slot_no            :integer(11)   not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class ContainerItem < ActiveRecord::Base

 belongs_to :container

 belongs_to :subject, :polymorphic => true

end
