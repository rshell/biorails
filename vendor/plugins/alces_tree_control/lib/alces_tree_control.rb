##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
# Methods added to this helper will be available to all templates in the application.
module Alces
 module TreeControl
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
        
        def to_tree(&block)
          item = {:text => self.name,
                  :id=>self.id,
                  :icon=>self.icon,
                  :qtip => self.tooltip,
                  :expanded => self.open,
                  :leaf=> true,
                  :cls=>'file'}
          if self.children.size>0
           item[:leaf] = false
           item[:children] = self.children.collect{|i|i.to_tree(&block)}   
         end
         yield item,self  if block_given? 
         return item
       end
      ##
      # id for node 
      #   
         def id        
            @id || 0
         end  
         
         def dom_id(scope=nil)
          return "#{scope}_#{id}"   if scope
           "#{id}" 
         end
         
      ##
      # This is @modelthe root node
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
                  if  hash[object.parent_id] && hash[object.parent_id].children.size>0
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

  end
end
