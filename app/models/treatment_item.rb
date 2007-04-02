# == Schema Information
# Schema version: 123
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
#
class TreatmentItem < ActiveRecord::Base

 belongs_to :group, :class_name => "TreatmentGroup", :foreign_key =>'treatment_group_id'

 belongs_to :subject, :polymorphic => true

end
