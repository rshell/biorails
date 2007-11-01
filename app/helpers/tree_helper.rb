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
 def build_column_tree(report,model,path="",level=0,max=4)
    old = nil
    tree = Alces::TreeControl::Node.create(model,:content_columns) do |node,rec|
         #logger.info "Node(#{model},#{path},#{level})  #{rec.name}"
         node.id = "#{report.model}~#{path}#{rec.name}"
         node.icon = "/images/relations/#{rec.type}.png" 
 	     node.iconCls="icon-#{rec.type}"
         node.name = rec.name
         #node.link =  reports_url({ :action =>'add_column',:id=>report.id, :column=>node.id })
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
		   node.iconCls="icon-#{relation.macro}"
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

  def json_for_report_columns(report)
      tree= build_column_tree(report, report.model)
	  return tree.to_tree.to_json
  end
  
  def tree_for_report_columns(report) 
      tree= build_column_tree(report, report.model)
      out = ""
      out << "<div id='#{report.dom_id(:tree)}'>"
      out << '</div>'
      script = <<JS
Ext.onReady( function(){  
      
      var tree = new Ext.tree.TreePanel('#{report.dom_id(:tree)}', {
                                      animate:true,
                                      autoScroll:true,
                                      loader: new Ext.tree.TreeLoader(), 
                                      lines: true,
                                      enableDrag: true,
                                      containerScroll: true,
                                      singleExpand: true,
                                      ddGroup: 'ColumnDD',
                                      selModel: new Ext.tree.MultiSelectionModel(),
                                      containerScroll: false  });

      var root = new Ext.tree.AsyncTreeNode(#{tree.to_tree.to_json});
      tree.setRootNode(root);
      tree.render();
      root.expand();
      tree.on('dblclick',function(node,e){
        console.log("double click");
        new Ajax.Request('/reports/add_column/#{report.id}',
                    {asynchronous:true,
                     evalScripts:true,
                     parameters:'id='+encodeURIComponent(node.id) }); 
        return false;
      
      });
});
    
JS
      out << javascript_tag(script)
      return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return  "error: #{ex.message}"
  end
##
# Tree of report columns
# 
  def tree_for_report_columns2(report)
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
#
# General JOSN for folder elements 
#  @param folder to use
#  @param elements optional subset of elements to use in case of large folders
#  @return string json 
#
  def folder_to_json( folder,elements = nil) 
    elements ||= folder.elements 
    list = []
    if folder.parent_id
       list << {:id => folder.id,
	         :icon => '/images/model/folder.png',
             :position => -1,
             :left_limit => -1,
             :right_limit => -1,
             :name => link_to_remote('..', :url=>folder_url(:action=>'show',:id=>folder.parent_id)),
             :summary => '[parent folder]',
             :updated_by => folder.updated_by,
             :updated_at => folder.updated_at.strftime("%Y-%m-%d %H:%M:%S") }
    end
    elements.sort{|a,b|a.left_limit <=> b.left_limit}.each_with_index{|e,i| e.position=i} 
    elements.each do |item| 
         actions = " "
         actions << link_to( " Edit ",   content_url( :action => 'edit', :id => item ), :class => "button") if item.is_a? ProjectContent
         actions << link_to( " Edit ",     asset_url( :action => 'edit', :id => item ), :class => "button") if item.is_a? ProjectAsset
         actions << link_to( " Delete ", folder_url( :action => 'destroy', :id => item ), :class => "button", :confirm => 'Are you sure?',:method => "post") if item.child_count==0 
         list <<   {:id =>item.id,
                    :position => item.position,
                    :left_limit => item.left_limit,
                    :right_limit => item.right_limit,
                    :icon =>  item.icon( {:images=>true} ),
                    :name =>  link_to_remote(item.name, :url=>element_to_url(item)),
                    :summary => item.summary,
					:reference_type => item.reference_type, 
                    :updated_by => item.updated_by,
                    :updated_at => item.updated_at.strftime("%Y-%m-%d %H:%M:%S"), 
                    :actions =>  actions }
    end
    {:folder_id => folder.id, :path => folder.path,  :total => list.size,:items => list }.to_json	    
  end
  
  def tree_to_json(folder)
    items = folder.to_tree do |node,rec|   
         node[:href] = reference_to_url(rec)
         node[:icon] = rec.icon
    end 
    items.to_json      
  end

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
	     :iconCls =>  "icon-concept",	
	     :leaf => (rec.children.count==0),
	     :qtip => rec.description		
      }
    end 
    items.to_json      
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
