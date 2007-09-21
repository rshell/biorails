# == Schema Information
# Schema version: 280
#
# Table name: treatment_groups
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :text          
#  study_id           :integer(11)   
#  experiment_id      :integer(11)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

# == Schema Information
# Schema version: 233
#
# Table name: treatment_groups
#
#  id            :integer(11)   not null, primary key
#  name          :string(128)   default(), not null
#  description   :text          
#  study_id      :integer(11)   
#  experiment_id :integer(11)   
#  lock_version  :integer(11)   default(0), not null
#  created_by    :string(32)    default(), not null
#  created_at    :datetime      not null
#  updated_by    :string(32)    default(), not null
#  updated_at    :datetime      not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class TreatmentGroup < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  belongs_to :study
 
  belongs_to :experiment
 
  has_many :items, :class_name => "TreatmentItem", 
                  :dependent => :destroy
 

end
