##
# Module to handle status changes with the lifecycle of a status of a object.
# 
# This expects the following attribute in the base class
#  status
#  accepted_at
#  completed_at
# 
  module CurrentPriority
##
# Allowed status values 
#  
  LOW    =0
  NORMAL =1
  HIGH   =2

###
# Status to human readable version for display
# 
  PRIORITIES = {NORMAL =>'normal',
                LOW=>'low',
                HIGH =>'high',
                nil =>'undefined' }

  def allowed_priority_list
   list = []
   for item in PRIORITIES.keys
     list << [PRIORITIES[item],item]
   end
   return list    
  end
  
  def priority
   return PRIORITIES[self.priority_id]   
  end          

  def priority=(value)
    case value
    when Fixnum
      self.priority_id = value
    when String
      self.priority_id =  PRIORITIES.invert[value]  
    else
      self.priority_id == value.id
    end
    return  PRIORITIES[self.priority_id]
  end
end