##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
module SheetHelper
  
# Convert Parameter collection for use in ExtJS
#
  def paramater_collection(parameters)
    return parameters.collect do |i|
              {:id => i.id,
               :index => i.dom_id, 
               :name => i.name,
               :unit => i.display_unit,
               :label => "#{i.name} #{i.display_unit}",
               :description => "#{i.name} #{i.display_unit} \n #{i.description}",
               :style => i.style,
               :regex => (i.data_format_id ? i.data_format.format_regex : nil),
               :regexText => (i.data_format_id ? i.data_format.description : nil),
               :column_no => i.column_no,  
               :data_type_id => i.data_type_id,
               :data_format_id => i.data_format_id,
               :data_element_id => i.data_element_id,
               :assay_parameter_id => i.assay_parameter_id,
               :default_value => i.default_value,
               :unit => i.display_unit,
               :mandatory => i.mandatory,
              }  
    end        
  end
  
  def context_definition(context, url = nil) 
    url ||= "/protocols/context/#{context.id}"
    item = {:id => context.id,
            :url => url,
            :parent_id => context.parent_id,
            :level_no => context.level_no,
            :default_count => context.default_count,
            :label => context.label,
            :path => context.path,
            :lock_version => context.lock_version,
            :protocol_version_id => context.protocol_version_id,
            :parameter_context_id=>context.id,
            :parameters => paramater_collection(context.parameters)
            }
    return item.to_json        
  end
  #
  # Definition of a context in json for use in ExtJS for creation of a table in the protocol
  #
  def context_model(context, url = nil) 
    url ||= "/protocols/context/#{context.id}"
    item = {:id => context.id,
            :url => url,
            :parent_id => context.parent_id,
            :level => context.level_no,
            :name => context.label,
            :path => context.path,
            :total => context.parameters.size,
            :items => paramater_collection(context.parameters)
            }
    return item.to_json        
  end
#
# Build a json table definition for use in ExtJS
#
  def context_values(task,definition,url = nil) 
    data = task.to_hash(definition)
    data[:parameters] = paramater_collection(definition.parameters)
    data[:url]= url || "/tasks/cell_value/#{task.id}"        
    return data.to_json        
  end


end

