# == Schema Information
# Schema version: 239
#
# Table name: treatment_items
#
#  id                 :integer(11)   not null, primary key
#  treatment_group_id :integer(11)   not null
#  subject_type       :string(255)   default(), not null
#  subject_id         :integer(11)   not null
#  sequence_order     :integer(11)   not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
# A TreatmentItem links the experimental subject into the a group 
# for use in a task. This is part of a the standard terms used in clinical structures
# for a group of people the same series of actions are carried out on. 
#
# At present this is simple part of our demo inventory systems. In real life more work
# would be needed to add from richness.
#
class TreatmentItem < ActiveRecord::Base

 belongs_to :group, :class_name => "TreatmentGroup", :foreign_key =>'treatment_group_id'
##
# Most likily another  model type like User 
 belongs_to :subject, :polymorphic => true

  validates_presence_of :group
  validates_presence_of :subject

end
