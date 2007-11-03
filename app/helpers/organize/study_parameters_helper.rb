##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
module Organize::StudyParametersHelper
# 
# Convert a array of study parameters to json
#
  def study_parameters_to_json(elements)
    items = elements.collect do |rec| 
	  {
		 :id => "sp_#{rec.id}",
		 :text => rec.name,
	     :icon =>  "/images/model/parameter.png",	
	     :leaf => true,
	     :qtip => rec.description		
      }
    end 
    items.to_json      
  end

# 
# Convert a array of project elenments to json
#
  def study_queues_to_json(elements)
    items = elements.collect do |rec| 
	  {
		 :id => "sq_#{rec.id}",
		 :text => rec.name,
	     :icon => "/images/model/queue_item.png",	
	     :leaf => true,
	     :qtip => rec.description		
      }
    end 
    items.to_json      
  end
# 
# Convert a array of parameter roles to json
#
  def parameter_roles_to_json(elements)
    items = elements.collect do |rec| 
	  {
		 :id => rec.id,
		 :text => rec.name,
	     :leaf => false,
	     :qtip => rec.description		
      }
    end 
    items << {
		 :id => 'queue',
		 :text => 'Service Queues',
	     :icon =>  "/images/model/request_service.png",	
	     :leaf => false,
	     :qtip => 'Service queues linked back to parameters '  
    }
    items.to_json      
  end
 

  
end
