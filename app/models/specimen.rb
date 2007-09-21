# == Schema Information
# Schema version: 280
#
# Table name: specimens
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :text          
#  weight             :float         
#  sex                :string(255)   
#  birth              :datetime      
#  age                :datetime      
#  taxon_domain       :string(255)   
#  taxon_kingdom      :string(255)   
#  taxon_phylum       :string(255)   
#  taxon_class        :string(255)   
#  taxon_family       :string(255)   
#  taxon_order        :string(255)   
#  taxon_genus        :string(255)   
#  taxon_species      :string(255)   
#  taxon_subspecies   :string(255)   
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


class Specimen < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
end
