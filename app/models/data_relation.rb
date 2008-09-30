# == Schema Information
# Schema version: 359
#
# Table name: data_relations
#
#  id              :integer(4)      not null, primary key
#  from_concept_id :integer(4)      not null
#  to_concept_id   :integer(4)      not null
#  role_concept_id :integer(4)      not null
#


##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

###
# May be a little not UML like but allow the capture of complex relationships between
# concepts. 
#
class DataRelation < ActiveRecord::Base

  belongs_to :to,   :class_name =>'DataConcept', :foreign_key=>'to_concept_id', :dependent => :destroy
  belongs_to :from, :class_name =>'DataConcept', :foreign_key=>'to_concept_id', :dependent => :destroy
  belongs_to :role, :class_name =>'DataConcept', :foreign_key=>'to_concept_id', :dependent => :destroy

##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

end
