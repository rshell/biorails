##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
# Methods added to this helper will be available to all templates in the application.
module TreeHelper

##
# This is a wrapper for use of dTree.js in ruby. It allow the simple creation of trees
# from ActiveRecord models. If the model implements acts_as_tree then a tree can be automatically
# created via 
#
class Node 
##
# Add in needed helpers
   
   cattr_accessor :seq 
   attr_accessor :id
   attr_accessor :model
   attr_accessor :icon
   attr_accessor :drag
   attr_accessor :drop_url
   

   attr_accessor :name       # Text Label of the Node
   attr_accessor :tooltip    # Long tooltip for the node
   attr_accessor :link       # url to fire on the node
   attr_accessor :open        # open/close boolean

   attr_accessor :parent     # parent of this node in the tree   
   attr_accessor :children   # children of this node in the tree
   attr_accessor :successor  # next on level
   attr_accessor :previous   # prev on level

   @@seq =0
##
# Node Creator from params hash or model
#     
   def initialize(object)
      @model = object
      @name = object.name if object.respond_to?(:name)
      @open = true
      @drag = true
      @drop_url = nil
      @event_name = "href"
      @tooltip =''
      @children = []
      
      @id = @@seq +=1
      yield self if block_given?   
   end   

##
# Defeult logger got tracing problesm
  def logger
    ActionController::Base.logger rescue nil
  end 
##
# id for node 
#   
   def id        
      @id || 0
   end  
   
   def dom_id(scope=nil)
    return "node_#{scope}_#{id}"

   end
   
##
# This is the root node
#
  def root?
    parent.nil?
  end
  
  def drag?
    (@drag == true)
  end
  
  def drop?
    !@drop_url.nil?
  end
##
# Create a node and its children 
# 
# * rec = object to use
# * label = name of ICONSthe method to use to as a label
# * children = name of the method to use as a collection for details
# 
#   
   def add_node(object, children=:children, &block)
     if object
       node = Node.create(object,children, &block)
       node.parent = self  
       self.children << node
       return node
     end
   end

  def add_collection(items,&block)
    old =nil
    for item in items
        child = self.add_node(item, &block)
		child.previous = old
		old.successor = child unless old.nil?
		old = child
     end   
  end
##
# Build tree from single sorted query of tree 
#  xxxx.find(:all,:order=>'parent_id,name' )
#   
  def Node.build( collection, &block )
     hash = {}
     root = nil
     collection.each do |object| 
        node = Node.new(object)
        root ||= node
        node.model = object
        hash[object.id] = node
        if object.parent_id
            if hash[object.parent_id].children.size>0
              old = hash[object.parent_id].children.last
              node.previous = old
              old.successor = node
            end
            node.parent = hash[object.parent_id]  
            hash[object.parent_id].children << node  
        end
       yield node,object  if block_given?        
      end         
      return root
  end 
##
# Create a node and its children 
# 
# * rec = object to use
# * label = name of the method to use to as a label
# * children = name of the method to use as a collection for details
#   
   def Node.create(object, children=:children, &block)
     if object
       node = Node.new(object)
       node.model = object
       if object.respond_to?(children)    
	     node.add_collection(object.send(children),&block)
       end
       yield node,object  if block_given?        
       return node
     end
   end   

   
  def display_style
    if open
      "style='display: block;'"
    else
      "style='display: none;'"
    end
  end 
##
# correct folder icon
# 
  def folder_icon
      return "<img src='#{@icon}' alt=''/>"  if @icon
      if self.has_children
        "<img src='/images/tree/folder.gif' alt=''/>"
      else
        "<img src='/images/tree/page.gif' alt=''/>"
      end
  end
##
# +/- symbols for functions to open/close tree  
# 
  def status_icon
      if self.open
        "<img src='/images/tree/minus.gif' alt=''/>"
      else
        "<img src='/images/tree/plus.gif' alt=''/>"
      end
  end
##
# Draw the correct lines to jon up nodes  
# 
  def join_icon
      if self.parent.nil? 
          '<img src="/images/tree/jointop.png" alt=""/>'      
      elsif self.successor.nil?
         '<img src="/images/tree/joinbottom.png" alt=""/>'
      else
          '<img src="/images/tree/join.png" alt=""/>'
      end
  end
  
  def has_children
    return !(self.children.nil? or self.children.size ==0)
  end       
      
end
##########################################################################################################
# Main Helper functions
# 
# tree_html <= Tree
# node_html <= node
#
#

##
# Generate html for full tree
# 
  def tree_html(tree)
    out = ""
    out << "<div id='#{tree.dom_id}' class='dtree'>"
    out << node_html(tree, 0 )
    out << '</div>'
    return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return  "error: #{ex.message}"
  end

##
# Generate html for a tree node
# 
  def node_html(node,level,ajax=false)     
      out = ""
      out << "<div id='#{node.dom_id(:node)}' class='clip' style='display: block;'>"
      out << "   <div class='node'>"
      2.upto(level) { |i|  out << '<img src="/images/tree/line.png" alt=""/>'  }          
      out << node.join_icon
      if node.has_children
        out << link_to_function(  node.status_icon,nil ) do |page|
             page[node.dom_id(:child)].toggle
        end
      end
      
      out << "<span id='#{node.dom_id}' class='#{node.model.class.to_s.underscore}'>"
      out << node.folder_icon 
      out << node.name.to_s if node.name
      out << node.link if node.link
      out << "</span>"
      out << "</div>"
      if node.has_children
        out << "<div id='#{node.dom_id(:child)}' class='children clip' #{node.display_style} >"
        for child in node.children 
          out << node_html(child,level+1,ajax) 
        end
        out << "</div>"
      else
        out << draggable_element(node.dom_id ,:zindex=>1999,:scroll=> true,:ghosting => true, :revert=> true) if node.drag?
      end 
      if node.drop?
         out << drop_receiving_element(node.dom_id(:node),
               :hoverclass => "drop-active",
               :url => node.drop_url )
      end
      out << '</div>'
      return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return  "error: #{ex.message}"
  end

##
# Convert the catalogue into a sett
# 
  def tree_for_catalog( context)
      tree=TreeHelper::Node.create(context) do |node,rec|
         node.link = link_to_remote rec.name, :url => catalogue_url(:action=>:show,:id=>rec)
         node.drop_url = nil
      end    
      tree.link = link_to_remote context.name, :url => catalogue_url(:action=>:show,:id=>context)         
      out = ""
      out << "<div id='#{context.dom_id(:tree)}' class='dtree'>"
      out << node_html(tree, 0 ,true)
      out << '</div>'
      return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return "Failed in tree_for_catalog"
   end


##
# Build tree structure as a nested set of lists
# 
 def build_column_tree(report,model,path="",level=0,max=2)
    old = nil
    tree =TreeHelper::Node.create(model,:content_columns) do |node,rec|
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
      tree=TreeHelper::Node.build(project.folders) do |node,rec|
          node.link = link_to rec.name,reference_to_url(rec )
          node.icon = rec.icon
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
# Tree for a folder and children  
# 
  def tree_for_collection(project , folders)
      tree=TreeHelper::Node.build(folders) do |node,rec|
          node.link = link_to rec.name,reference_to_url(rec )
          node.icon = rec.icon
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
