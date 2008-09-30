# == Schema Information
# Schema version: 359
#
# Table name: data_elements
#
#  id                 :integer(4)      not null, primary key
#  name               :string(50)      default(""), not null
#  description        :string(1024)    default(""), not null
#  data_system_id     :integer(4)      not null
#  data_concept_id    :integer(4)      not null
#  access_control_id  :integer(4)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  parent_id          :integer(4)
#  style              :string(10)      default(""), not null
#  content            :string(4000)    default("")
#  estimated_count    :integer(4)
#  type               :string(255)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# Subtype of a DataElement for a internally managed list of text items.
# This can be entered  as a comma separated list and converted to a list 
# of child elements.
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 

class ListElement < DataElement
  #
  # after save of masters read the content and convert to child items
  #
  after_save :populate 

#
# Check the SQL is valid 
#
  def validate
    logger.info "Checkling list #{content}"
    unless FasterCSV.parse(content).size>0
      errors.add(:content,"Cant find any items on list '#{content}'")      
    end
  rescue Exception => ex
    errors.add(:content,"Cant Parse list #{ex.message}")
    return false
  end
  
  
protected
  def populate
     estimated_count = 0
     FasterCSV.parse(content) do |row|
       row.each do |item|
           add_child(item)
           estimated_count +=1
       end
     end
  end

end
