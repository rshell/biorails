# == Schema Information
# Schema version: 239
#
# Table name: batches
#
#  id                 :integer(11)   not null, primary key
#  compound_id        :integer(11)   default(0), not null
#  name               :string(255)   
#  description        :text          
#  external_ref       :string(255)   
#  quantity_unit      :string(255)   
#  quantity_value     :float         
#  url                :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#


##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class Batch < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description

  belongs_to :compound
  
  validates_presence_of :compound_id
  validates_format_of(:name, :with => /^[A-Z][A-Z][0-9]/, :message => "Name should look like AAnnnn")
  
  before_create :id_generation
  before_validation_on_create :batch_id_generation
  
  def id_generation
    self.external_ref = self.compound.name + "-" + self.compound.batches.size.to_s if self.compound
  end
  
  def batch_id_generation
    self.name = "BB" + Batch.count.to_s if self.compound
  end

end

