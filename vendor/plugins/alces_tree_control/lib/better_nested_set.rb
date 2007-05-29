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
          
          configuration = { :order => nil, 
                            :counter_cache => nil, 
                            :parent_column => "parent_id", 
                            :left_column => "left_limit", 
                            :right_column => "right_limit", 
                            :scope => "1 = 1" }         
                            
          configuration.update(options) if options.is_a?(Hash)          
          configuration[:scope] = "#{configuration[:scope]}_id".intern if configuration[:scope].is_a?(Symbol) && configuration[:scope].to_s !~ /_id$/
          
          if configuration[:scope].is_a?(Symbol)
            scope_condition_method = %(
              def scope_condition
                if #{configuration[:scope].to_s}.nil?
                  "#{configuration[:scope].to_s} IS NULL"
                else
                  "#{configuration[:scope].to_s} = \#{#{configuration[:scope].to_s}}"
                end
              end
            )
          else
            scope_condition_method = "def scope_condition() \"#{configuration[:scope]}\" end"
          end

          belongs_to :parent,  :class_name => name, :foreign_key => configuration[:parent_column], :counter_cache => configuration[:counter_cache]
          has_many  :children, :class_name => name, :foreign_key => configuration[:parent_column], :order => configuration[:order], :dependent => :destroy
          
          class_eval <<-EOV
            include Alces::Acts::NestedSet::InstanceMethods

            #{scope_condition_method}
            
            def left_col_name() "#{configuration[:left_column]}" end
            def right_col_name() "#{configuration[:right_column]}" end
            def parent_column() "#{configuration[:parent_column]}" end

            def self.roots
              find(:all, :conditions => "#{configuration[:foreign_key]} IS NULL", :order => #{configuration[:order].nil? ? "nil" : %Q{"#{configuration[:order]}"}})
            end

            def self.root
              find(:first, :conditions => "#{configuration[:foreign_key]} IS NULL", :order => #{configuration[:order].nil? ? "nil" : %Q{"#{configuration[:order]}"}})
            end
            
          EOV

        end
      end        

      module InstanceMethods

        # Returns true is this is a root node.  
        def root?
          parent_id = self[parent_column]
          (parent_id == 0 || parent_id.nil?) && (self[left_col_name] == 1) && (self[right_col_name] > self[left_col_name])
        end                                                                                             
                                    
        # Returns true is this is a child node
        def child?                          
          parent_id = self[parent_column]
          !(parent_id == 0 || parent_id.nil?) && (self[left_col_name] > 1) && (self[right_col_name] > self[left_col_name])
        end     
        
        # Returns true if we have no idea what this is
        def unknown?
          !root? && !child?
        end
        
        # order by left column
        def <=>(other)
          self[left_col_name] <=> other[left_col_name]
        end

        # Returns root
        def root
             self.class.base_class.find(:first, 
             :conditions => "#{scope_condition} AND (#{parent_column} IS NULL)"  )
        end
                                      
        # Returns an array of all parents 
        # Maybe 'full_outline' would be a better name, but we prefer to mimic the Tree class
        def ancestors
            self.class.base_class.find(:all, 
            :conditions => ["#{scope_condition} AND #{left_col_name} < ? and #{right_col_name} > ? ",self[left_col_name],self[right_col_name] ],
            :order => left_col_name )
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
            if self[parent_column].nil? || self[parent_column].zero?
                [self]
            else
                self.class.base_class.find(:all, 
                :conditions => ["#{scope_condition}  and #{parent_column} =?", self[parent_column]], 
                :order => left_col_name)
            end
        end
        
        # Returns the level of this object in the tree
        # root level is 0
        def level
            return 0 if self[parent_column].nil?
             self.class.base_class.count(
            :conditions => ["#{scope_condition} AND (#{left_col_name} < ? and #{right_col_name} > ?)", self[left_col_name], self[right_col_name]])        
        end                                  
        
       # Returns the number of nested children of this object.
        def children_count
          return (self[right_col_name] - self[left_col_name] - 1)/2
        end
                                                               
        # Returns a set of itself and all of its nested children
        def full_set
          self.class.base_class.find(:all, :conditions => ["#{scope_condition} AND (#{left_col_name} BETWEEN ? and ?",self[left_col_name], self[right_col_name]] )
        end
                  
        # Returns a set of all of its children and nested children
        def all_children
          self.class.base_class.find(:all, :conditions => ["#{scope_condition} AND (#{left_col_name} > ?) and (#{right_col_name} < ?)",self[left_col_name],self[right_col_name]] )
        end
                                  
        # Returns a set of only this entry's immediate children
        def direct_children
          self.class.base_class.find(:all, :conditions => ["#{scope_condition} and #{parent_column} = ?",self.id] )
        end

                                      
        # Prunes a branch off of the tree, shifting all of the elements on the right
        # back to the left so the counts still work.
        def before_destroy
          return if self[right_col_name].nil? || self[left_col_name].nil?
          dif = self[right_col_name] - self[left_col_name] + 1

          self.class.base_class.transaction do
            self.class.base_class.delete_all( "#{scope_condition} and #{left_col_name} > #{self[left_col_name]} and #{right_col_name} < #{self[right_col_name]}" )
            self.class.base_class.update_all( "#{left_col_name} = (#{left_col_name} - #{dif})",  "#{scope_condition} AND #{left_col_name} >= #{self[right_col_name]}" )
            self.class.base_class.update_all( "#{right_col_name} = (#{right_col_name} - #{dif} )",  "#{scope_condition} AND #{right_col_name} >= #{self[right_col_name]}" )
          end
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
          self.reload
          child.reload

          if child.root?
            raise "Adding sub-tree isn\'t currently supported"
          else
            if ( (self[left_col_name] == nil) || (self[right_col_name] == nil) )
              # Looks like we're now the root node!  Woo
              self[left_col_name] = 1
              self[right_col_name] = 4
              
              # What do to do about validation?
              return nil unless self.save
              
              child[parent_column] = self.id
              child[left_col_name] = 2
              child[right_col_name]= 3
              return child.save
            else
              # OK, we need to add and shift everything else to the right
              child[parent_column] = self.id
              right_bound = self[right_col_name]
              child[left_col_name] = right_bound
              child[right_col_name] = right_bound + 1
              self[right_col_name] += 2
              self.class.base_class.transaction do
                  self.class.base_class.update_all( "#{left_col_name} = (#{left_col_name} + 2)",  "#{scope_condition} AND #{left_col_name} >= #{right_bound}" )
                  self.class.base_class.update_all( "#{right_col_name} = (#{right_col_name} + 2)",  "#{scope_condition} AND #{right_col_name} >= #{right_bound}" )
                  self.save
                  child.save
              end
            end
          end                                   
        end  

protected 
        def move_to(target, position)
          target.add_child(self) if (  self.id.nil? || (self[left_col_name] == nil) || (self[right_col_name] == nil) )
                  
          # use shorter names for readability: current left and right
          cur_left, cur_right = self[left_col_name], self[right_col_name] 
              
          # extent is the width of the tree self and children
          extent = cur_right - cur_left + 1
          
          # load object if node is not an object
          target_left, target_right = target[left_col_name], target[right_col_name]

          # detect impossible move
          if ((cur_left <= target_left) && (target_left <= cur_right)) or ((cur_left <= target_right) && (target_right <= cur_right))
            raise ActiveRecord::ActiveRecordError, "Impossible move, target node cannot be inside moved tree."
          end
        
          # compute new left/right for self
          if position == :child
            if target_left < cur_left
              new_left  = target_left + 1
              new_right = target_left + extent
            else
              new_left  = target_left - extent + 1
              new_right = target_left
            end
          elsif position == :left
            if target_left < cur_left
              new_left  = target_left
              new_right = target_left + extent - 1
            else
              new_left  = target_left - extent
              new_right = target_left - 1
            end
          elsif position == :right
            if target_right < cur_right
              new_left  = target_right + 1
              new_right = target_right + extent 
            else
              new_left  = target_right - extent + 1
              new_right = target_right
            end
          else
            raise ActiveRecord::ActiveRecordError, "Position should be either left or right ('#{position}' received)."
          end
          
          # boundaries of update action
          b_left, b_right = [cur_left, new_left].min, [cur_right, new_right].max
          
          # Shift value to move self to new position
          shift = new_left - cur_left
          
          # Shift value to move nodes inside boundaries but not under self_and_children
          updown = (shift > 0) ? -extent : extent
          
          # change nil to NULL for new parent
          if position == :child
            new_parent = target.id
          else
            new_parent = target[parent_column].nil? ? 'NULL' : target[parent_column]
          end
          
          # update and that rules
          # update and that rules
          self.class.base_class.update_all( "#{left_col_name} = CASE \
                                      WHEN #{left_col_name} BETWEEN #{cur_left} AND #{cur_right} \
                                        THEN #{left_col_name} + #{shift} \
                                      WHEN #{left_col_name} BETWEEN #{b_left} AND #{b_right} \
                                        THEN #{left_col_name} + #{updown} \
                                      ELSE #{left_col_name} END, \
                                  #{right_col_name} = CASE \
                                      WHEN #{right_col_name} BETWEEN #{cur_left} AND #{cur_right} \
                                        THEN #{right_col_name} + #{shift} \
                                      WHEN #{right_col_name} BETWEEN #{b_left} AND #{b_right} \
                                        THEN #{right_col_name} + #{updown} \
                                      ELSE #{right_col_name} END, \
                                  #{acts_as_nested_set_options[:parent_column]} = CASE \
                                      WHEN #{self.class.primary_key} = #{self.id} \
                                        THEN #{new_parent} \
                                      ELSE #{acts_as_nested_set_options[:parent_column]} END",
                                  acts_as_nested_set_options[:scope] )
          self.reload
        end
        
      end
      
    end
  end
end
