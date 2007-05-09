##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
# Methods added to this helper will be available to all templates in the application.
module TreeHelper

  include Alces::TreeControl


##
# Build tree structure as a nested set of lists
# 
 def build_column_tree(report,model,path="",level=0,max=2)
    old = nil
    tree = Alces::TreeControl::Node.create(model,:content_columns) do |node,rec|
         #logger.info "Node(#{model},#{path},#{level})  #{rec.name}"
         node.id = "#{report.model}~#{path}#{rec.name}"
         node.icon = "/images/relations/#{rec.type}.png" 
         node.name = ""
         node.link =  link_to_remote rec.name + subject_icon("add.gif"),
                        :url=>{ :action =>'add_column',:id=>report.id, :column=>node.id }
  	     node.previous = old
    	 node.successor = node unless old.nil?
    	 old = node
     end  
     tree.link=nil
     tree.name="<b>#{report.model}</b>"
     return tree if level>=max  
     for relation in model.reflections.values
        unless (report.base_model==relation.class_name) or (relation.macro==:has_many and level>0) or relation.options[:polymorphic]
           #logger.info "Reference(#{model},#{path},#{level})  #{relation.macro}  #{relation.class_name}"
           
           node = build_column_tree(report, eval(relation.class_name), "#{path}#{relation.name}.",level+1,max)
           node.id = "#{path}#{relation.name}"
           node.icon = "/images/relations/#{relation.macro}.png" 
           node.name = relation.name
           node.link = nil
           node.parent = tree
    	   node.open = false
    	   node.previous = old
    	   old.successor = node unless old.nil?
    	   old = node
           tree.children << node
        end
      end
      return tree
 end    

##
# Tree of report columns
# 
  def tree_for_report_columns(report)
      tree= build_column_tree(report, report.model)
      out = ""
      out << "<div id='#{report.dom_id(:tree)}' class='dtree'>"
      out << node_html(tree, 0 ,true)
      out << '</div>'
      return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return "Error in tree_for_report_columns:  #{ex.message}"
   end
          
##
# Generate a Tree for a project
#
  def tree_for_project(project)
      tree= Alces::TreeControl::Node.build(project.folders) do |node,rec|
          node.link = link_to rec.name,reference_to_url(rec )
          node.icon = rec.icon
          node.id = rec.dom_id
          node.name = nil
          node.drop_url = nil
#          node.drop_url = folder_url(:action =>"drop_element",:id => rec.id)
      end    
      out = ""
      out << "<div id='#{project.dom_id(:tree)}' class='dtree'>"
      out <<  node_html(tree, 0 )
      out << '</div>'
      return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return  "error: #{ex.message}"
  end
 
 
##
# Tree for a folder and children  
# 
  def tree_for_folder(project , folder)
      tree= Alces::TreeControl::Node.create( folder ) do |node,rec|
          node.link = link_to rec.name,element_to_url(rec )
          node.icon = rec.icon
          node.id = rec.dom_id
          node.name = nil
          node.drop_url = nil
#          node.drop_url = folder_url(:action =>"drop_element",:id => rec.id)
      end    
      out = ""
      out << "<div id='#{project.dom_id(:tree)}' class='dtree'>"
      out << node_html(tree, 0 )
      out << '</div>'
      return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return  "error: #{ex.message}"
  end
  
  
 

##
# Convert a element in to a url call to display it
#    
  def element_to_url(element)
    if element.content_id
       content_url(:action=>'show', :id=>element.id, :folder_id=>element.parent_id )
    elsif element.asset_id
       asset_url(:action=>'show',:id=>element.id, :folder_id=>element.parent_id )
    else
       folder_url(:action=>'show', :id=> element.id )
    end
  end  

##
# Convert a type/id reference into a url to the correct controlelr
#    
  def reference_to_url(element)
    case element.attributes['reference_type']
    when 'Project' :        project_url(:action=>'show', :id=>element.reference_id )
    when 'ProjectContent':  content_url(:action=>'show', :id=>element.id ,:folder_id=>element.parent_id )
    when 'ProjectAsset' :   asset_url(:action=>'show',:id=>element.id,:folder_id=>element.parent_id )
    when 'Study' :          study_url(:action=>'show', :id=> element.reference_id )
    when 'StudyParameter':  study_parameter_url(:action=>'show', :id=> element.reference_id )
    when 'StudyProtocol':   protocol_url(:action=>'show', :id=> element.reference_id )
    when 'Experiment':      experiment_url(:action=>'show', :id=> element.reference_id )
    when 'Task':            task_url(:action=>'show', :id=> element.reference_id )
    when 'Report':          report_url(:action=>'show', :id=> element.reference_id )
    when 'Request':         request_url(:action=>'show', :id=> element.reference_id )
    when 'Compound':        compound_url(:action=>'show', :id=> element.reference_id )
    else
       element_to_url(element)
    end
  end  

end
