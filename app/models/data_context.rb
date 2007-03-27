
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
