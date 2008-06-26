# == Schema Information
# Schema version: 306
#
# Table name: data_concepts
#
#  id                 :integer(11)   not null, primary key
#  parent_id          :integer(11)   
#  name               :string(50)    default(), not null
#  data_context_id    :integer(11)   default(0), not null
#  description        :string(1024)  default(), not null
#  access_control_id  :integer(11)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  type               :string(255)   default(DataConcept), not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#


##
# Specific type for root of a conceptual space a Context.
# 
class DataContext < DataConcept

  has_many :roots, :class_name =>'DataConcept',:conditions => "parent_id=0", :foreign_key=>'data_context_id', :dependent => :destroy

  has_many :concepts, :class_name =>'DataConcept', :foreign_key=>'data_context_id', :dependent => :destroy

  has_many :systems, :class_name =>'DataSystem'
  
  def path
     name
  end

end
