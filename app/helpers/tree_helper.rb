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

def folder_to_json(folder) 
    list = [] 
    if folder 
      folder.elements.each do |item| 
         actions = " "
         actions << link_to( "Edit",   content_url( :action => 'edit', :id => item ), :class => "button") if item.is_a? ProjectContent
         actions << link_to( "Edit",     asset_url( :action => 'edit', :id => item ), :class => "button") if item.is_a? ProjectAsset
         actions << link_to( "Delete", folder_url( :action => 'destroy', :id => item ), :class => "button", :confirm => 'Are you sure?',:method => "post") if item.child_count==0 
         list <<   [item.id,
                     item.icon( {:images=>true} ),
                     link_to(item.name, element_to_url(item)),
                     item.summary,
                     item.updated_by,
                     item.updated_at.strftime("%Y-%m-%d %H:%M:%S"), 
                     actions,
                     item.to_html  ]
      end
     end
     list.to_json      
  end
  
  def tree_to_json(folder)
    items = folder.to_tree do |node,rec|   
         node[:href] = reference_to_url(rec)
         node[:icon] = rec.icon
    end 
    items.to_json      
  end
          
  def tree_for_project(project) 
      items = project.home.to_tree do |node,rec|   
         node[:href] = reference_to_url(rec)
         node[:icon] = rec.icon
      end   
      out = ""
      out << "<div id='#{project.dom_id(:tree)}'>"
      out << '</div>'
      script = <<JS
Ext.onReady( function(){  
      
      var tree = new Ext.tree.TreePanel('#{project.dom_id(:tree)}', {
                                      animate:true,
                                      enableDD:false,
                                      loader: new Ext.tree.TreeLoader(), 
                                      lines: true,
                                      selModel: new Ext.tree.MultiSelectionModel(),
                                      containerScroll: false });

      var root = new Ext.tree.AsyncTreeNode(#{items.to_json});
      tree.setRootNode(root);
      tree.render();
      root.expand()
});
    
JS
      out << javascript_tag(script)
      return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return  "error: #{ex.message}"
  end
  
 
   def  tree_for_folder(project , folder)
      items =folder.to_tree do |node,rec|   
         node[:href] = element_to_url(rec)
         node[:icon] = rec.icon
      end   
      out = ""
      out << "<div id='#{folder.dom_id(:tree)}'>"
      out << '</div>'
      script = <<JS
Ext.onReady( function(){       
      var tree = new Ext.tree.TreePanel('#{folder.dom_id(:tree)}', {
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

      var root = new Ext.tree.AsyncTreeNode(#{items.to_json});
      tree.setRootNode(root);
      tree.render();
      root.expand()
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
