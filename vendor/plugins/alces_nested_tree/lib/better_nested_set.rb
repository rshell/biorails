require "set"
# based on  better_nested_set
# (c) 2005 Jean-Christophe Michel 
# MIT licence
#
module Alces
  module Acts #:nodoc:
    module NestedSet #:nodoc:
    
      def self.append_features(base)
        super        
        base.extend(ClassMethods)              
      end  

      # better_nested_set ehances the core nested_set tree functionality provided in ruby_on_rails.
      #
      # This acts provides Nested Set functionality. Nested Set is a smart way to implement
      # an _ordered_ tree, with the added feature that you can select the children and all of their 
      # descendents with a single query. The drawback is that insertion or move need some complex
      # sql queries. But everything is done here by this module!
      #
      # Nested sets are appropriate each time you want either an orderd tree (menus, 
      # commercial categories) or an efficient way of querying big trees (threaded posts).
      #
      # == API
      # Methods names are aligned on Tree's ones as much as possible, to make replacment from one 
      # by another easier, except for the creation:
      # 
      # in acts_as_tree:
      #   item.children.create(:name => "child1")
      #
      # in acts_as_nested_set:
      #   # adds a new item at the "end" of the tree, i.e. with child.left = max(tree.right)+1
      #   child = MyClass.new(:name => "child1")
      #   child.save
      #   # now move the item to its right place
      #   child.move_to_child_of my_item
      #
      # You can use:
      # * move_to_child_of
      # * move_to_right_of
      # * move_to_left_of
      # and pass them an id or an object.
      #
      # Other methods added by this mixin are:
      # * +root+ - root item of the tree (the one that has a nil parent; should have left_column = 1 too)
      # * +roots+ - root items, in case of multiple roots (the ones that have a nil parent)
      # * +level+ - number indicating the level, a root being level 0
      # * +ancestors+ - array of all parents, with root as first item
      # * +self_and_ancestors+ - array of all parents and self
      # * +siblings+ - array of all siblings, that are the items sharing the same parent and level
      # * +self_and_siblings+ - array of itself and all siblings
      # * +children_count+ - count of all immediate children
      # * +children+ - array of all immediate childrens
      # * +all_children+ - array of all children and nested children
      # * +full_set+ - array of itself and all children and nested children
      #
      # recommandations:
      # Don't name your left and right columns 'left' and 'right': these names are reserved on most of dbs.
      # Usage is to name them 'lft' and 'rgt' for instance.
      #
      module ClassMethods                
        # Configuration options are:
        #
        # * +parent_column+ - specifies the column name to use for keeping the position integer (default: parent_id)
        # * +left_column+ - column name for left boundry data, default "lft"
        # * +right_column+ - column name for right boundry data, default "rgt"
        # * +text_column+ - column name for the title field (optional). Used as default in the 
        #   {your-class}_options_for_select helper method. If empty, will use the first string field 
        #   of your model class.
        # * +scope+ - restricts what is to be considered a list. Given a symbol, it'll attach "_id" 
        #   (if that hasn't been already) and use that as the foreign key restriction. It's also possible 
        #   to give it an entire string that is interpolated if you need a tighter scope than just a foreign key.
        #   Example: <tt>acts_as_nested_set :scope => 'todo_list_id = #{todo_list_id} AND completed = 0'</tt>
        def acts_as_fast_nested_set(options = {})          
          
          write_inheritable_attribute(:acts_as_nested_set_options,
            { :order => 'left_limit',  
              :counter_cache => nil,  
              :scope => "1 = 1" }.merge(options))  
           
          class_inheritable_reader :acts_as_nested_set_options                               

          if acts_as_nested_set_options[:scope].is_a?(Symbol)
            scope_condition_method = %(
              def nested_set_scope_condition
                if #{acts_as_nested_set_options[:scope].to_s}.nil?
                  "#{acts_as_nested_set_options[:scope].to_s} IS NULL"
                else
                  "#{acts_as_nested_set_options[:scope].to_s} = \#{#{acts_as_nested_set_options[:scope].to_s}}"
                end
              end
            )
          else
            scope_condition_method = "def nested_set_scope_condition() \"#{acts_as_nested_set_options[:scope]}\" end"
          end

          module_eval <<-"end_eval", __FILE__, __LINE__
            #{scope_condition_method}
          end_eval
          
          before_destroy :before_destroy_remove_children

          before_create :before_create_set_limits
          
          belongs_to :parent,  
            :class_name => name, 
            :foreign_key => :parent_id, 
            :counter_cache => acts_as_nested_set_options[:counter_cache]
                     
          has_many  :children, 
            :class_name => name, 
            :foreign_key => :parent_id, 
            :order => acts_as_nested_set_options[:order], 
            :dependent => :destroy
          
          include Alces::Acts::NestedSet::InstanceMethods
          extend  Alces::Acts::NestedSet::SetClassMethods
        end
      end
        
      module SetClassMethods
        #
        # Define the scope conditions method for use later
        #

        def roots
          find(:all, :conditions => "parent_id IS NULL",  :order => "left_limit,id")
        end

        def root
          find(:first, :conditions => "parent_id IS NULL",  :order => "left_limit,id")
        end
          
        # Checks the left/right indexes of all records, 
        # returning the number of records checked. Throws ActiveRecord::ActiveRecordError if it finds a problem.
        def check_all
          total = 0
          transaction do
            # if there are virtual roots, only call check_full_tree on the first, because it will check other virtual roots in that tree.
            total = roots.inject(0) do |sum, r| 
              sum + (r.left_limit == 1 ? r.check_full_tree : 0 )
            end
            unless base_class.count == total
              raise ActiveRecord::ActiveRecordError, "Scope problems or nodes without a valid root #{base_class.count} == #{total}" 
            end
          end
          return total
        end

        # Re-calculate the left/right values of all nodes. Can be used to convert 
        # ordinary trees into nested sets.
        def renumber_all
          scopes = []
          # only call it once for each scope_condition 
          # (if the scope conditions are messed up, this will obviously cause problems)
          roots.each do |r|
            r.renumber_full_tree unless scopes.include?(r.nested_set_scope_condition)
            scopes << r.nested_set_scope_condition
          end
        end  
        #
        # Rebuild all the set based on the parent_id and text_column name
        #
        def rebuild_sets
          renumber_all
        end
        #          
        # Returns an SQL fragment that matches _items_ *and* all of their descendants, for 
        # use in a WHERE clause.
        # You can pass it a single object, a single ID, or an array of objects and/or IDs.
        #   # if a.lft = 2, a.rgt = 7, b.lft = 12 and b.rgt = 13
        #   Set.sql_for([a,b]) # returns "((lft BETWEEN 2 AND 7) OR (lft BETWEEN 12 AND 13))"
        # Returns "1 != 1" if passed no items. If you need to exclude items, just use "NOT 
        # (#{sql_for(items)})".
        # Note that if you have multiple trees, it is up to you to apply your scope condition.
        #
        def sql_for(items)
          items = [items] unless items.is_a?(Array)
          # get objects for IDs
          items.collect! {|s| s.is_a?(acts_as_nested_set_options[:class]) ? s : acts_as_nested_set_options[:class].find(s)}.uniq
          items.reject! {|e| e.new_record?} # exclude unsaved items, since they don't have left/right values yet
          
          return "1 != 1" if items.empty? # PostgreSQL didn't like '0', and SQLite3 didn't like 'FALSE'
          items.map! do |e| 
            "(#{left_column} BETWEEN #{e[:left_limit]} AND #{e[:right_limit]})" 
          end
          "(#{items.join(' OR ')})"
        end
        

      end
    

      module InstanceMethods
                                       
        # On creation, automatically add the new node to the right of all existing nodes in this tree.
        def before_create_set_limits # already protected by a transaction
          unless  self.left_limit and self.right_limit
            maxright = self.class.base_class.maximum(:right_limit, :conditions => self.nested_set_scope_condition) || 0
            self.left_limit = maxright+1
            self.right_limit = maxright+2
          end
        end
        
        # Prunes a branch off of the tree, shifting all of the elements on the right
        # back to the left so the counts still work.
        def before_destroy_remove_children
          return if self.right_limit.nil? || self.left_limit.nil?
          #self.reload # in case a concurrent move has altered the indexes
          dif = self.right_limit - self.left_limit + 1

          self.class.base_class.delete_all( "#{nested_set_scope_condition} AND (left_limit BETWEEN #{self.left_limit} AND #{self.right_limit})" )
          self.class.base_class.update_all("left_limit = CASE \
                                      WHEN left_limit > #{right_limit} THEN (left_limit - #{dif}) \
                                      ELSE left_limit END, \
                                      right_limit = CASE \
                                      WHEN right_limit > #{right_limit} THEN (right_limit - #{dif} ) \
                                      ELSE right_limit END",
            nested_set_scope_condition) 

        end

        #
        # rebuild test left/right levels
        #  
        def rebuild_set
          renumber_full_tree
        end
        #
        #
        #
        def reorder_before(destination)
          logger.info "Move #{self.id} before #{destination.id}"
          if self.parent_id ==  destination.parent_id
             self.move_to_left_of destination
            true
          else
            false
          end
        end
        #
        #
        # 
        def reorder_after(destination)
          logger.info "Move #{self.id} before #{destination.id}"
          if self.parent_id ==  destination.parent_id
            self.move_to_right_of destination   
            true
          else
            false
          end
        end
      
        # By default, records are compared and sorted using the left column.
        # order by left column
        def <=>(other)
          self.left_limit <=> other.left_limit
        end

        def contains?(target)
            return false if target.nested_set_scope_condition != nested_set_scope_condition
            (target.left_limit >= self.left_limit) && (target.right_limit <= self.right_limit)
        end
        
        # Returns true is this is a root node.  
        def root?
          parent_id = self.parent_id
          (parent_id == 0 || parent_id.nil?) && (self.left_limit == 1) && (self.right_limit > self.left_limit)
        end                                                                                             
                                    
        # Returns true is this is a child node
        def child?                          
          parent_id = self.parent_id
          !(parent_id == 0 || parent_id.nil?) && (self.left_limit > 1) && (self.right_limit > self.left_limit)
        end     
              
        # Deprecated. Returns true if we have no idea what this is
        def unknown?
          !root? && !child?
        end
        
        # Returns root
        def root
          self.class.base_class.find(:first, 
            :conditions => "#{nested_set_scope_condition} AND (parent_id IS NULL)"  )
        end
        
        # Returns the root or virtual roots of this record's tree (a tree cannot have more than one real root). See the explanation of virtual roots in the README.
        def roots
          self.class.base_class.find(:all, :conditions => "#{nested_set_scope_condition} AND parent_id IS NULL ", :order => "left_limit")
        end        
        #                              
        # With the nested set model, we can retrieve a single path without having multiple self-joins: 
        #
        def ancestors
            self.class.base_class.find(:all, 
            :conditions => ["#{nested_set_scope_condition} AND left_limit < ? and right_limit > ? ", self.left_limit, self.right_limit],
            :order => :left_limit )
        end
        
        # Returns the array of all parents and self
        def self_and_ancestors
            ancestors + [self]
        end
        
        # Returns the array of all children of the parent, except self
        def siblings
          self_and_siblings - [self]
        end
        
        # Returns the array of all children of the parent, included self
        def self_and_siblings
          if self.parent_id.nil? || self.parent_id.zero?
            [self]
          else
            self.class.base_class.find(:all, 
              :conditions => ["#{nested_set_scope_condition}  and parent_id =?", self.parent_id], 
              :order => :left_limit)
          end
        end
        
        # Returns the level of this object in the tree
        # root level is 0
        def level
          return 0 if self.parent_id.nil?
          self.class.base_class.count(
            :conditions => ["#{nested_set_scope_condition} AND (left_limit BETWEEN ? AND ?)", 
              self.left_limit, self.right_limit]) -1       
        end                                  
        
        # Returns the number of nested children of this object.
        def all_children_count
          return (self.right_limit - self.left_limit - 1)/2
        end
       
        #
        #Finding all leaf nodes in the nested set model even simpler than the LEFT JOIN method used in the adjacency list model. 
        # If you look at the nested_category table, you may notice that the lft and rgt values for leaf nodes are consecutive numbers.
        #To find the leaf nodes, we look for nodes where right = left + 1:
        #
        def all_leaf_node
          self.class.base_class.find(:all, :conditions => ["#{nested_set_scope_condition} AND (right_limit = left_limit+1)"] )
        end
        #
        # Find all leaf node under the current node
        #
        def left_nodes
          self.class.base_class.find(:all, 
            :conditions => ["#{nested_set_scope_condition} AND (right_limit = left_limit+1) AND (left_limit BETWEEN ? and ?)",
              self.left_limit, self.right_limit] )          
        end

        
        # Returns a set of itself and all of its nested children
        def full_set
          self.class.base_class.find(:all, 
            :conditions => ["#{nested_set_scope_condition} AND (left_limit BETWEEN ? and ?)",self.left_limit, self.right_limit] )
        end
                  
        # Returns a set of all of its children of current node
        #
        # We can retrieve the full tree through the use of a self-join that links parents with nodes on the basis 
        # that a node's left limit  value will always appear between its parent's left and right limit values
        # 
        # eg. select * from tree where node.left between parent.left and parent.right
        #
        def all_children
          self.class.base_class.find(:all, 
            :conditions => ["#{nested_set_scope_condition} AND (left_limit > ?) and (right_limit < ?)",self.left_limit,self.right_limit] )
        end
                                  
        # Returns a set of only this entry's immediate children
        #
        # eg. select * from tree where parent_id = id
        #  
        def direct_children
          self.class.base_class.find(:all, :conditions => ["#{nested_set_scope_condition} and parent_id = ?",self.id] )
        end

        # Returns this record's terminal children (nodes without children).
        def leaves
          self.class.base_class.find(:all, 
            :conditions => ["#{nested_set_scope_condition} AND (left_limit BETWEEN ? and ?) AND (right_limit = left_limit+1)",self.left_limit, self.right_limit],
            :order => left_limit)
        end
        
        # Returns the count of this record's terminal children (nodes without children).
        def leaves_count
          self.class.base_class.count(
            :conditions => ["#{nested_set_scope_condition} AND (left_limit BETWEEN ? and ?)  AND (right_limit = left_limit+1)",self.left_limit, self.right_limit])
        end

        # Checks the left/right indexes of one node and all descendants. 
        # Throws ActiveRecord::ActiveRecordError if it finds a problem.
        def check_subtree
          transaction do
            self.reload
            check # this method is implemented via #check, so that we don't generate lots of unnecessary nested transactions
          end
        end

        # Checks the left/right indexes of the entire tree that this node belongs to, 
        # returning the number of records checked. Throws ActiveRecord::ActiveRecordError if it finds a problem.
        # This method is needed because check_subtree alone cannot find gaps between virtual roots, orphaned nodes or endless loops.
        def check_full_tree
          total_nodes = 0
          transaction do
            # virtual roots make this method more complex than it otherwise would be
            n = 1
            roots.each do |r| 
              raise ActiveRecord::ActiveRecordError, "Gaps between roots in the tree containing record ##{r.id}" if r[:left_limit] != n
              r.check_subtree
              n = r[:right_limit] + 1
            end
            total_nodes = roots.inject(0) {|sum, r| sum + r.all_children_count + 1 }
            expected_nodes = self.class.base_class.count(:conditions => "#{nested_set_scope_condition}")
            unless expected_nodes  == total_nodes
              raise ActiveRecord::ActiveRecordError, "Orphaned nodes or endless loops in the tree containing record ##{self.dom_id} expected_nodes [#{expected_nodes}]  != total_nodes [#{total_nodes}]"
            end
          end
          return total_nodes
        end

        # Re-calculate the left/right values of all nodes in this record's tree. Can be used to convert an ordinary tree into a nested set.
        def renumber_full_tree
          indexes = []
          n = 1
          transaction do
            for r in roots # because we may have virtual roots
              n = r.calc_numbers(n, indexes)
            end
            for i in indexes
              self.class.base_class.update_all("left_limit = #{i[:lft]}, right_limit = #{i[:rgt]}", "#{self.class.primary_key} = #{i[:id]}")
            end
          end
          ## reload?
        end
        
        # Move the node to the left of another node (you can pass id only)
        def move_to_left_of(node)
          self.move_to node, :left
        end
        
        # Move the node to the left of another node (you can pass id only)
        def move_to_right_of(node)
          self.move_to node, :right
        end
        
        # Move the node to the child of another node (you can pass id only)
        def move_to_child_of(node)
          self.move_to node, :child
        end
        
        
        # Adds a child to this object in the tree.  If this object hasn't been initialized,
        # it gets set up as a root node.  Otherwise, this method will update all of the
        # other elements in the tree and shift them to the right, keeping everything
        # balanced. 
        def add_child( child )     
          raise ActiveRecord::ActiveRecordError, "You cannot add child to unsaved node" if new_record?
          raise ActiveRecord::ActiveRecordError, "You add a alread saved child" unless child.new_record?
                    
          # OK, we need to add and shift everything else to the right
          self.class.base_class.transaction do
            child.parent_id = self.id
            right_bound = self.right_limit
            child.left_limit = right_bound
            child.right_limit = right_bound + 1
            self.class.base_class.update_all(
              "left_limit = CASE WHEN left_limit > #{right_bound}  THEN left_limit + 2  ELSE left_limit END, \
              right_limit = CASE WHEN right_limit >= #{right_bound}  THEN right_limit + 2 ELSE right_limit END ",
              "right_limit >= #{right_bound} and #{nested_set_scope_condition} ")
            child.save
          end
        end  

        protected 

        def move_to(target, position)
          raise ActiveRecord::ActiveRecordError, "You cannot move a unsaved new node" if new_record?
          raise ActiveRecord::ActiveRecordError, "You cannot move to unsaved target node" if target.new_record?
          raise ActiveRecord::ActiveRecordError, "You cannot move a node if left or right is nil" unless self.left_limit && self.right_limit
          transaction do
            self.reload # the lft/rgt values could be stale (target is reloaded below)
            if target.is_a?(self.class.base_class)
              target.reload # could be stale
            else
              target = self.class.base_class.find(target) # load object if we were given an ID
            end

            if (target.left_limit >= self.left_limit) && (target.right_limit <= self.right_limit)
              logger.error "Impossible move current[#{id}] #{left_limit}:#{right_limit} => target[#{target.id}] #{target.left_limit} : #{target.right_limit}"
              logger.debug "self = #{self.to_yaml}"
              logger.debug "target = #{target.to_yaml}"
              raise ActiveRecord::ActiveRecordError, "Impossible move, target #{target.id}  #{left_limit}:#{right_limit} node cannot be inside moved tree of #{self.id}  #{target.left_limit}:#{target.right_limit}."
            end
            # prevent moves between different trees
            if target.nested_set_scope_condition != nested_set_scope_condition
              logger.error "Scope missmatch current[#{id}] #{self.left_limit}:#{self.right_limit} => target[#{target.id}] #{target.left_limit} : #{target.right_limit}"
              logger.debug "self = #{self.to_yaml}"
              logger.debug "target = #{target.to_yaml}"
              raise ActiveRecord::ActiveRecordError, "Scope conditions do not match for #{id}. Is the target #{target.id} in the same tree?"
            end

            # the move: we just need to define two adjoining segments of the left/right index and swap their positions
            bound = case position
            when :child then target.right_limit
            when :left  then target.left_limit
            when :right then target.right_limit + 1
            else raise ActiveRecord::ActiveRecordError, "Position should be :child, :left or :right ('#{position}' received)."
            end
            
            if bound > self.right_limit
              bound = bound - 1
              other_bound = self.right_limit + 1
            else
              other_bound = self.left_limit - 1
            end
            
            return if bound == self.right_limit || bound == self.left_limit # there would be no change, and other_bound is now wrong anyway
            
            # we have defined the boundaries of two non-overlapping intervals, 
            # so sorting puts both the intervals and their boundaries in order
            a, b, c, d = [self.left_limit, self.right_limit, bound, other_bound].sort
            
            # change nil to NULL for new parent
            if position == :child
              new_parent = target.id
            else
              new_parent = target.parent_id.nil? ? 'NULL' : target.parent_id
            end
            
            self.class.base_class.update_all("\
              #{:left_limit} = CASE \
                WHEN #{:left_limit} BETWEEN #{a} AND #{b} THEN #{:left_limit} + #{d - b} \
                WHEN #{:left_limit} BETWEEN #{c} AND #{d} THEN #{:left_limit} + #{a - c} \
                ELSE #{:left_limit} END, \
              #{:right_limit} = CASE \
                WHEN #{:right_limit} BETWEEN #{a} AND #{b} THEN #{:right_limit} + #{d - b} \
                WHEN #{:right_limit} BETWEEN #{c} AND #{d} THEN #{:right_limit} + #{a - c} \
                ELSE #{:right_limit} END, \
                 parent_id = CASE \
                WHEN #{self.class.primary_key} = #{self.id} THEN #{new_parent} \
                ELSE parent_id END",
              nested_set_scope_condition)
            self.reload
            target.reload
          end
        end
            
        def check #:nodoc:
          # performance improvements (3X or more for tables with lots of columns) by using :select to load just id, lft and rgt
          ## i don't use the scope condition here, because it shouldn't be needed
          my_children = self.class.base_class.find(:all, :conditions => "parent_id = #{self.id}",
            :order => :left_limit, :select => "#{self.class.primary_key}, left_limit,right_limit")
          
          if my_children.empty?
            unless self[:left_limit] && self[:right_limit]
              raise ActiveRecord::ActiveRecordError, "#{self.dom_id}. right_limit or left_limit is blank"
            end
            unless self[:right_limit] - self[:left_limit] == 1
              raise ActiveRecord::ActiveRecordError, "#{self.dom_id}.right_limit should be 1 greater than left_limit"
            end
          else
            n = self[:left_limit]
            for c in (my_children) # the children come back ordered by lft
              unless c[:left_limit] && c[:right_limit]
                raise ActiveRecord::ActiveRecordError, "#{self.dom_id}.right_limit or left_limit is blank"
              end
              unless c[:left_limit] == n + 1
                raise ActiveRecord::ActiveRecordError, "#{self.dom_id}.left_limit should be 1 greater than #{n}"
              end
              c.check
              n = c[:right_limit]
            end
            unless self[:right_limit] == n + 1
              raise ActiveRecord::ActiveRecordError, "#{self.dom_id}.right_limit should be 1 greater than #{n}"
            end
          end
        end
        
        # used by the renumbering methods
        def calc_numbers(n, indexes) #:nodoc:
          my_lft = n
          # performance improvements (3X or more for tables with lots of columns) by using :select to load just id, lft and rgt
          ## i don't use the scope condition here, because it shouldn't be needed
          #
          my_children = self.class.base_class.find(:all, 
            :conditions => "parent_id = #{self.id}",
            :order => :left_limit, 
            :select => "#{self.class.primary_key}, left_limit, right_limit")
          if my_children.empty?
            my_rgt = (n += 1)
          else
            for c in (my_children)
              n = c.calc_numbers(n + 1, indexes)
            end
            my_rgt = (n += 1)
          end
          indexes << {:id => self.id, :lft => my_lft, :rgt => my_rgt} unless self[:left_limit] == my_lft && self[:right_limit] == my_rgt
          return n
        end

      end
      
    end
  end
end

