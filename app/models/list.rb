# == Schema Information
# Schema version: 359
#
# Table name: lists
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)     not null
#  description        :string(1024)    default("")
#  type               :string(255)
#  expires_at         :datetime
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  data_element_id    :integer(4)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# This is the manager for a generic list of model instances for use as a
# common method to list handling code. The list of basic polymorphic
# references to objects.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class List < ActiveRecord::Base
   acts_as_dictionary :name 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

# Generic rules for a name and description to be present
  validates_presence_of :name
##
# List Has a number of items associated with it
# 
  belongs_to :data_element
  
  has_many :items, :class_name => "ListItem"
 
  ##
# Create a new task context
# 
 def add(new_value)
   logger.warn "add #{new_value} or class  #{new_value.class}"
   return nil if new_value.nil?
   item = ListItem.new
   item.list = self
   item.value = new_value
   self.items << item
   return item
 end
 
##
# Convert Name to DataValue(id,Name) from DataElement
# 
 def lookup(name)
   if self.data_element
       self.data_element.lookup(name)
   end
 end

##
# Convert id to DataValue(id,Name) from DataElement
# 
 def reference(id)
   if self.data_element
       self.data_element.reference(id)
   end
 end
 
end


