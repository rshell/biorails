# == Schema Information
# Schema version: 233
#
# Table name: data_relations
#
#  id              :integer(11)   not null, primary key
#  from_concept_id :integer(32)   not null
#  to_concept_id   :integer(32)   not null
#  role_concept_id :integer(32)   not null
#


##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class DataRelation < ActiveRecord::Base

  belongs_to :to,   :class_name =>'DataConcept', :foreign_key=>'to_concept_id', :dependent => :destroy
  belongs_to :from, :class_name =>'DataConcept', :foreign_key=>'to_concept_id', :dependent => :destroy
  belongs_to :role, :class_name =>'DataConcept', :foreign_key=>'to_concept_id', :dependent => :destroy
  acts_as_audited :except => [:created_by, :updated_by,:created_at,:updated_at,:lock_version]

end
