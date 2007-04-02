# == Schema Information
# Schema version: 123
#
# Table name: data_concepts
#
#  id                :integer(11)   not null, primary key
#  parent_id         :integer(11)   
#  name              :string(50)    default(), not null
#  data_context_id   :integer(11)   default(0), not null
#  description       :text          
#  access_control_id :integer(11)   
#  lock_version      :integer(11)   default(0), not null
#  created_by        :string(32)    default(sys), not null
#  created_at        :datetime      not null
#  updated_by        :string(32)    default(sys), not null
#  updated_at        :datetime      not null
#  type              :string(255)   default(DataConcept), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class DataConcept < ActiveRecord::Base

#
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>"parent_id"
  validates_presence_of :name
  validates_presence_of :description
  
  belongs_to :context, :class_name => 'DataContext', :foreign_key=>'data_context_id'
  
  has_many :elements,  :class_name => 'DataElement',:conditions => "parent_id is null",  :dependent => :destroy

  has_many :parameter_types,  :dependent => :destroy
  
  acts_as_tree :order => "name"  

##
# See if the parameter is used
# 
  def not_used
    return (parameter_types.size==0 and elements.size==0)
  end
  

#
# path to name
#
  def path
     if parent == nil 
        return "/"+name 
     else 
        return parent.path+"/"+name
     end 
  end 

#
# Find all the children of this the concept
#
  def decendents
     [self]+children.inject([]){|decendents,child|decendents+child.decendents}
  end
   
#
# Overide context_columns to remove all the internal system columns.
# 
  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }
        
  end  
end
