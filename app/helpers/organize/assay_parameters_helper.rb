##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
module Organize::AssayParametersHelper
# 
# Convert a array of assay parameters to json
#
  def assay_parameters_to_json(elements)
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
  def assay_queues_to_json(elements)
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
		 :text => 'Assay Queues',
	     :icon =>  "/images/model/request.png",	
	     :leaf => false,
	     :qtip => 'Service queues linked back to parameters '  
    }
    items.to_json      
  end
 

  
end
