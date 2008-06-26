module Biorails
  module UmlModel
    COLOURS = ['#40e0d0','#ffffb3','#ffe4b5','#e6f5d0','#e6e6fa','#e0ffff','#ffefdb','#dcdcdc',
               '#ffe1ff','#ffe4b5','#ffe4c4','#ffe4e1','#ffffd9','#ffffe0','#ffffe5',
               '#fffff0','#ffec8b','#ffed6f','#ffeda0','#ffefd5','#ffefdb']
  
    GRAPHIZ_STYLES = ['dot','neato','twopi','fdp']
 
##
# Defeult logger got tracing problesm
  def UmlModel.logger
    ActionController::Base.logger rescue nil
  end

##
# List of all controllers in the system
# 
# returns a Has of controllers index by name
#
  def UmlModel.controllers
    for file in Dir.glob("#{RAILS_ROOT}/app/controllers/*.rb") do
      begin
        load file
      rescue
        logger.info "Couldn't load file '#{file}' (already loaded?)"
      end
    end
    
    classes = Hash.new
    
    ObjectSpace.each_object(Class) do |klass|
      if klass.respond_to? :controller_name
        if klass.superclass.to_s == ApplicationController.to_s
          classes[klass.controller_name] = klass
        end
      end
    end
    return classes
  rescue Exception => ex
    logger.warning "Failed to find controller #{ex.message}"
    return []
  end

##
# Get a List of all the Models
#   
  def UmlModel.models
    unless @models
      for file in Dir.glob("#{RAILS_ROOT}/app/models/*.rb") do
        begin
          load file
        rescue
          logger.info "Couldn't load file '#{file}' (already loaded?)"
        end
      end  
    end
    @models = []

    ObjectSpace.each_object(Class) do |klass|
      if klass.ancestors.any?{|item|item==ActiveRecord::Base} and !klass.abstract_class
        @models << klass unless @models.any?{|item|item.to_s == klass.to_s}
      end
    end

    @models -= [ActiveRecord::Base, CGI::Session::ActiveRecordStore::Session]
    return @models.sort{|a,b| a.to_s <=> b.to_s }

  rescue Exception => ex
    logger.error "Failed to find models #{ex.message}"
    return []
  end
    
     
###
# Output model for node definition for a model for use in graphviz 
# This task the model and generates a record node with all key attributes
# listed
# 
  def UmlModel.dot_model(model,label,color)
      node =""
      if model and !model.abstract_class and model < ActiveRecord::Base  
        logger.info "dot_model(#{model})"
        attrs =""
        begin
          for col in model.content_columns
             col_type = col.type.to_s
             col_type << "(#{col.limit})" if col.limit
             attrs << "#{col.name} : #{col_type}"
             attrs << ", default: \\\"#{col.default}\\\"" if col.default
             attrs << "\\n"
          end
          for relation in model.reflections.values
             col_type = col.type.to_s
             attrs << "#{relation.name} "
             if relation.options[:polymorphic] 
              attrs << "[ #{relation.macro}  *polymorphic* ]" 
             else
               attrs << "[#{relation.macro} #{relation.class_name}]"
             end
             attrs << "\\n"      
          end
        rescue Exception => ex
            logger.info "problem with #{model} #{ex.message}"
           attrs << "!!! Changing !!!"
           attrs << "\\n"
        end
        node << "\t\"#{model.to_s}\""
        node << " [label=\"{#{model.to_s} [#{label}]|#{attrs}}\" "
        node << " ,style=\"filled\",fillcolor=\"#{color}\" shape=\"record\"];\n"
      else
        ""  
      end
      return node
  rescue Exception => ex
    logger.warning "Failed to create dot_models #{ex.message}"
  end
   
##
# Generate a dot and image filea for a model showing all its relationships
# If this works you get a file name back to point to the png for the model
# 
  def UmlModel.create_model_diagram(target_dir,root, options ={})
      return nil unless root && root < ActiveRecord::Base && !root.abstract_class
      max_levels = (options[:levels] || 2).to_i
      max_many = (options[:many] || 1).to_i
      cmd = GRAPHIZ_STYLES.detect{|cmd|cmd==options[:style]} ||GRAPHIZ_STYLES[0]
  
      logger.info "create_model_diagram model #{root} levels #{max_levels} manys #{max_many} draw with #{cmd}"
  
      img_file = File.join(target_dir,"model_#{root}_#{max_levels}_#{max_many}_#{cmd}.png")
      dot_file = File.join(target_dir, "model_#{root}_#{max_levels}_#{max_many}_#{cmd}.dot")      
      nodes = {} 
      relations =[]  
      queue = []
      nodes[root]=dot_model(root,"root",COLOURS[0])
      queue << {:model=>root,:level=>1}
  
      while queue.size>0
         node = queue.pop
         for relation in node[:model].reflections.values.reject {|r|r.options[:polymorphic] ||  (r.macro==:has_many and node[:level]> max_many ) }
  
           model = eval(relation.class_name)
           relations << "\t\"#{node[:model].to_s}\" -> \"#{model.to_s}\" "
           case relation.macro
           when :has_many
           relations << " [label=\" has many #{relation.name}\",color=\"blue\", arrowtail=\"odiamond\", arrowhead=\"crow\"] \n"        
           when :belongs_to
           relations << " [label=\" reference #{relation.name}\", arrowhead=\"normal\",  arrowtail=\"none\"] \n"        
           when :has_one
           relations << " [label=\" has one #{relation.name}]\", arrowhead=\"diamond\"] \n"        
           else
           relations << " [label=\" #{relation.macro} #{relation.name}\" ] \n"        
           end
           
           unless nodes[model] or node[:level]>=max_levels
             nodes[model] = dot_model(model,"level #{node[:level]}",COLOURS[node[:level]]) 
             queue << {:model=>model,:level=>( node[:level]+1 ) }
          end
        end
      end   
  
      f = File.open(dot_file, "w")    
      # Define a graph and some global settings
      f.write "digraph G {\n"
      f.write "\toverlap=false;\n \tsplines=true;\n"
      f.write "\tnode [fontname=\"Helvetica\",fontsize=7];\n"
      f.write "\tedge [fontname=\"Helvetica\",fontsize=7];\n"
      f.write "\tranksep=0.1;\n \tnodesep=0.1;\n"
      #f.write "\tedge [decorate=\"true\"];\n"
  
      # Write header info
      f.write "\t_schema_info [shape=\"plaintext\", label=\"\", fontname=\"Helvetica\",fontsize=8];\n"
      
      assocs = []
      # Draw the tables as boxes
      for node in nodes.values
        f.write node
      end
      # Draw the relations
      for relation in relations
        f.write relation
      end    
      # Close the graph
      f.write "}\n"
      f.close
  
      # neato or dot
      if system "#{cmd} -Tpng -o\"#{img_file}\" \"#{dot_file}\""
        logger.info "Generated #{img_file}"
        return img_file
      else
        puts "Failed to execute the '#{cmd}' command! Need grapviz (www.graphviz.org) installed and on path "
        logger.error "Failed to execute the '#{cmd}' command! Is grapviz (www.graphviz.org) installed? "
        return nil
      end
    rescue Exception => ex
        logger.error "cant generate grapviz: #{ex.message}"
        return nil    
    end

  end
end