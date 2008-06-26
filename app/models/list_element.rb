# == Schema Information
# Schema version: 306
#
# Table name: data_elements
#
#  id                 :integer(11)   not null, primary key
#  name               :string(50)    default(), not null
#  description        :string(1024)  default(), not null
#  data_system_id     :integer(11)   not null
#  data_concept_id    :integer(11)   not null
#  access_control_id  :integer(11)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  parent_id          :integer(11)   
#  style              :string(10)    default(), not null
#  content            :string(4000)  default()
#  estimated_count    :integer(11)   
#  type               :string(255)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

###############################################################################################
# List  based in statement
# 
class ListElement < DataElement
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
