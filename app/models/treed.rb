##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class  Treed < ActiveRecord::Base
  self.abstract_class = true  
#
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>"parent_id"
  validates_presence_of :name
  validates_presence_of :description

#  belongs_to :access, :class_name => "AccessControl", :foreign_key => "access_control_id"

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