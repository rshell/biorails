##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
module  Named 

##
# Overide context_columns to remove all the internal system columns.
# 
  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }
  end

  def to_s
    return "#{self.dom_id} #{self.name}"
  end
  
  #
  # Defined Like method for use in a lookup
  #
  def self.like(name,limit = 20,offset=0)
    self.find(:all, :conditions=>['name like ? ',name+'%'], :limit=>limit, :offset=>offset)
  end

  #
  # Defined Like method for use in a lookup
  #
  def self.lookup(name)
    self.find(:first,    :conditions=>['name = ? ',name])
  end
  
end