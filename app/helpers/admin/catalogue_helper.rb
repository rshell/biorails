module Admin::CatalogueHelper
  
# 
# Convert a array of project elenments to json
#
#
  def data_concepts_to_json(elements)
    items = elements.collect do |rec| 
      {
      :id => rec.id,
      :text => rec.name,
      :url => catalogue_url(:action=>:show,:id => rec.id),
      #:iconCls =>  "icon-data_concept",	
      :leaf => (rec.children.count==0),
      :qtip => rec.description		
      }
    end 
    items.to_json      
  end
 
end
