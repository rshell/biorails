# == Schema Information
# Schema version: 123
#
# Table name: compounds
#
#  id                :integer(11)   not null, primary key
#  name              :string(50)    default(), not null
#  description       :text          
#  formula           :string(50)    
#  mass              :float         
#  smiles            :string(255)   
#  lock_version      :integer(11)   default(0), not null
#  created_by        :string(32)    default(sys), not null
#  created_at        :datetime      not null
#  updated_by        :string(32)    default(sys), not null
#  updated_at        :datetime      not null
#  registration_date :datetime      
#  iupacname         :string(255)   default()
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Compound < ActiveRecord::Base
 
  has_many :batches, :dependent => :destroy
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :registration_date

#
# Overide context_columns to remove all the internal system columns.
# 
  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }
  end

end
