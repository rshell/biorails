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
   attr_accessor :id
   attr_accessor :parent     # parent of this node in the tree   
   attr_accessor :children   # children of this node in the tree
   attr_accessor :name       # Text Label of the Node
   attr_accessor :url        # url to fire on the node
   attr_accessor :tooltip    # Long tooltip for the node
   attr_accessor :icon       # closed icon
   attr_accessor :icon_open  # open icon
   attr_accessor :event_name # 
   attr_accessor :open        # open/close boolean
   
##
# Node Creator from params hash or model
#     
   def initialize(name)
      @icon = ''
      @icon_open = ''
      @open = false
      @event_name = "href"
      @name = name
      @tooltip =''
      @children = [] 
      yield self if block_given?   
   end   

##
# id for node 
#   
   def id        
      @id ||=self.object_id.abs
   end  
##
# This is the root node
#
  def root?
    parent.nil?
  end
##
# Create a node and its children 
# 
# * rec = object to use
# * label = name of the method to use to as a label
# * children = name of the method to use as a collection for details
# 
#   
   def add_node(rec,label=:name, children=:children, &block)
     if rec
       node = Node.create(rec,label,children, &block)
       node.parent = self  
       self.children << node
       return node
     end
   end
##
# Create a node and its children 
# 
# * rec = object to use
# * label = name of the method to use to as a label
# * children = name of the method to use as a collection for details
#   
   def Node.create(rec,label=:name, children=:children, &block)
     if rec
       node = Node.new(rec.send(label))
       if rec.respond_to?(children)            
         for item in rec.send(children)
            node.add_node(item, &block)
         end   
       end
       yield node,rec  if block_given?        
       return node
     end
   end   

##
# Add a named collection to the tree
#
   def add_collection(name, collection, label=:name, children=:children,&block)       
      node=Node.new(name)
      node.parent = self
      self.children << node
      for item in collection
         child = node.add_node(item,label,children,&block)
      end 
      return node 
   end 

   def html_link=(url)
     @event_name = "href"
     @url=url
   end
   
   def ajax_link=(url)
     @event_name='onclick'
     @url="javascript: new Ajax.Request('#{url}', {asynchronous:true, evalScripts:true})"
   end
   
   def to_jscript(div_id)
     out = " #{div_id}.add(#{id}, #{@parent ? @parent.id : -1}, '#{@name}',\"#{@url}\",'#{@event_name}','#{@tooltip}',null,'#{@icon}','#{@icon_open}',#{@open});\n"
     self.children.each{|node| out << node.to_jscript(div_id)}
     return out
   end       
   
end

##
# Tree Structure management class for presentation of a Tree (Explorer Tree like)
# This code is basically taken from http://www.destroydrop.com/javascripts/tree/
# 
class Tree < Node 
   
   attr_accessor :div_id
   attr_accessor :folder_links  #Should folders be links.
   attr_accessor :use_selection  #Nodes can be selected(highlighted).
   attr_accessor :use_cookies  	#	The tree uses cookies to rember it's state.
   attr_accessor :use_lines 	#Tree is drawn with lines.
   attr_accessor :use_icons 	#Tree is drawn with icons.
   attr_accessor :use_status_text #	Displays node names in the statusbar instead of the url.
   attr_accessor :close_same_level #	Only one node within a parent can be expanded at the same time. openAll() and closeAll() functions do not work when this is enabled.
   attr_accessor :in_order 	#	If parent nodes are always added before children, setting this to true speeds up the tree.

##
# Node Creator from params hash or model
#     
   def initialize(name)
      @icon = ''
      @icon_open = ''
      @open = false
      @event_name = "href"
      @target =''
      @name = name
      @title =''
      @tooltip =''
      @children = [] 
      @folder_links=true
      @use_selection=true
      @use_cookies=false
      @use_lines=true
      @use_icons =true
      yield self if block_given?   
   end   
##
# Get the name of the div_id and jscript variable to contain the tree
#    
  def div_id
    @div_id ||="dtree_#{id}"
  end 
##
# Convert a option into a jscript setting   
# 
   def output_option(name,value)
      state = (value ? 'true' : 'false')
      " #{div_id}.config.#{name.to_s} =#{state}"
   end
##
# output a javascript 
#          
   def to_html   
	out =  "<a href='javascript: #{div_id}.openAll();'>open all</a> |<a href='javascript: #{div_id}.closeAll();'>close all</a> \n"    
    out << "<script> \n"
    out <<"#{div_id} = new dTree('#{div_id}');"
    out << output_option(:folderLinks,@folder_links) << ";\n"
    out << output_option(:useSelection,@use_selection) << ";\n"
    out << output_option(:useCookies,@use_cookies) << ";\n"
    out << output_option(:useLines,@use_lines) << ";\n"
    out << output_option(:useIcons,@use_icons) << ";\n"
    out << output_option(:useStatusText,@use_status_text) << ";\n"
    out << output_option(:closeSameLevel,@close_same_level) << ";\n"
    out << output_option(:inOrder,@in_order)  << ";\n"
    out << to_jscript(div_id)   
    out << "document.write(#{div_id});\n"
    out << "</script>\n"
    return out  
   end 

end

 
  def tree_for_catalog( context)
      tree = TreeHelper::Tree.new(context.name)  
      tree.ajax_link = catalogue_url(:action=>:show,:id=>context)         
      tree.close_same_level = true
       for item in context.children
          tree.add_node(item) do |node,rec|
               node.ajax_link = catalogue_url(:action=>:show,:id=>rec)
          end    
       end   
      return tree.to_html
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return "Failed in tree_for_catalog"
   end
  
  
  def tree_for_all
      tree= TreeHelper::Tree.new('Root')
      tree.close_same_level = true
      catalog = tree.add_collection('Catalog',DataContext.find(:all),:name,:concepts)  do |node,rec|
          node.url = catalogue_url(:action=>:show,:id=>rec) 
      end    
      
      catalog.add_collection('Users',User.find(:all),:name) do |node,rec|
          node.url = user_url(:action=>:show,:id=>rec) 
          node.icon ="/images/user.png"          
      end
      
      catalog.add_collection('Roles',Role.find(:all),:name) do |node,rec|
          node.url = role_url(:action=>:show,:id=>rec) 
          node.icon ="/images/role.png"
      end
      
      catalog.add_collection('Formats',DataFormat.find(:all),:name) do |node,rec|
          node.url = data_format_url(:action=>:show,:id=>rec) 
          node.icon ="/images/data_format.png"
      end
      
      catalog.add_collection('Parameters',ParameterType.find(:all),:name) do |node,rec|
          node.url = parameter_type_url(:action=>:show,:id=>rec) 
          node.icon ="/images/parameter.png"
      end 
      
      tree.add_collection('Projects',Project.find(:all),:name,:folders) do |node,rec|
          node.url = study_url(:action=>:show,:id=>rec) 
      end
      
      tree.add_collection('Studies',Study.find(:all))  do |node,rec|
          node.url = study_url(:action=>:show,:id=>rec) 
          node.icon ="/images/study.png"
      end
      
      tree.add_collection('Experiments',Experiment.find(:all)) do |node,rec|
          node.url = experiment_url(:action=>:show,:id=>rec) 
          node.icon ="/images/experiment.png"
      end 
      
      tree.add_collection('Requests',Request.find(:all)) do |node,rec|
          node.url = request_url(:action=>:show,:id=>rec) 
      end 
      return tree.to_html
   rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return "Failed in tree_for_all"
   end
  
##
# Generate a Tree for a project
#
  def tree_for_project(project)
      tree=TreeHelper::Tree.new('Project')
      tree.use_cookies = true
      folders = tree.add_node(project.home,:name) do |node,rec|
          node.html_link = element_to_url(rec)
          node.icon = "/images/model/#{rec.style.downcase}.png"
      end    
      folders.open = true
      return tree.to_html
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return "Failed in tree_for"
   end  
   
   
  def element_to_url(element)
    case element.attributes['reference_type']
    when 'ProjectContent'
       folder_url(:action=>'article', :id=>element.id ,:folder_id=>element.parent_id )

    when 'ProjectAsset'
       folder_url(:action=>'asset',:id=>element.id,:folder_id=>element.parent_id )

    when 'Study'
       study_url(:action=>'show', :id=> element.reference_id )
       
    when 'Experiment'
       experiment_url(:action=>'show', :id=> element.reference_id )
       
    when 'Task'
       task_url(:action=>'show', :id=> element.reference_id )
       
    when 'StudyProtocol'
       protocol_url(:action=>'show', :id=> element.reference_id )

    when 'StudyParameter'
       study_parameter_url(:action=>'show', :id=> element.reference_id )
       
    else
       folder_url(:action=>'show', :id=> element.id )
    end
  end  

end
