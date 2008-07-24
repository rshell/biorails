# == Description
# Simple internal dictionary of Stages within a assay. These are used to partition
# protocols and provide a general cascade in the reporting views.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
# == Schema Information
# Schema version: 338
#
# Table name: assay_stages
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :string(1024)  default(), not null
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#
class AssayStage < ActiveRecord::Base
  
   acts_as_dictionary :name 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
  acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
                              :description=>{:store=>:yes,:boost=>0},
                               }, 
                   :default_field => [:name],           
                   :single_index => true, 
                   :store_class_name => true 
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name
  has_many :protocols, :class_name =>'AssayProtocol', :dependent => :destroy
end
