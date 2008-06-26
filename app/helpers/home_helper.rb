##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

module HomeHelper  
# 
# Convert a array of project elenments to json
#
#
  def elements_to_json(elements)
    items = elements.collect do |rec| 
      {
      :id => rec.id,
      :text => rec.name,
      :href => reference_to_url(rec),
      :icon => rec.icon,
      :iconCls =>  "icon-#{rec.class.to_s.underscore}",
      :allowDrag => !(rec.class == ProjectFolder),
      :allowDrop => (rec.class == ProjectFolder),	
      :leaf => !(rec.class == ProjectFolder),
      :qtip => rec.summary		
      }
    end 
    items.to_json      
  end
  
end
