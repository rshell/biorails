# == Schema Information
# Schema version: 239
#
# Table name: lists
#
#  id                 :integer(11)   not null, primary key
#  name               :string(255)   
#  description        :text          
#  type               :string(255)   
#  expires_at         :datetime      
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  data_element_id    :integer(11)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

class List < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
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
   logger.warn new_value
   logger.warn  new_value.class
   return nil if new_value.nil?
   item = ListItem.new
   item.list = self
   case new_value
   when String
       logger.warn "is String"
       value = lookup(new_value)  
       return nil unless value
       item.data_type = value.class.to_s
       item.data_id   = value.id  
       item.data_name = value.name 

    when Fixnum
       logger.warn "is Fixnum"
       value = reference(new_value)      
       return nil unless value
       item.data_type = value.class.to_s
       item.data_id   = value.id  
       item.data_name = value.name 
    when ListItem
       logger.warn "is ListItem"
       item.data_type = new_value.data_type
       item.data_id   = new_value.data_id 
       item.data_name = new_value.data_name 
    else
      logger.warn "is unknown"
      self.data_type = new_value.data_type if new_value.respond_to?(:date_type)
      self.data_id   = new_value.data_id if new_value.respond_to?(:date_id)
      self.data_name = new_value.data_name if new_value.respond_to?(:date_name)
   end
   items << item
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
       self.data_element.reference(name)
   end
 end
 
end


