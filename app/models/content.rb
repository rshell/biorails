class Content < ActiveRecord::Base 
  include ActionView::Helpers::NumberHelper
  set_table_name 'project_contents'

  belongs_to :project, :class_name=>'Project', :foreign_key => 'project_id'
  belongs_to :created_by_user, :class_name=>'User', :foreign_key => 'created_by_user_id'
  belongs_to :updated_by_user, :class_name=>'User', :foreign_key => 'updated_by_user_id'
##
# This record has a full audit log created for changes 
#   
# You can use:
# * move_to_child_of
# * move_to_right_of
# * move_to_left_of
# and pass them an id or an object.
#
# Other methods added by acts_as_nested_set are:
# * +root+ - root item of the tree (the one that has a nil parent; should have left_column = 1 too)
# * +roots+ - root items, in case of multiple roots (the ones that have a nil parent)
# * +level+ - number indicating the level, a root being level 0
# * +ancestors+ - array of all parents, with root as first item
# * +self_and_ancestors+ - array of all parents and self
# * +siblings+ - array of all siblings, that are the items sharing the same parent and level
# * +self_and_siblings+ - array of itself and all siblings
# * +count+ - count of all immediate children
# * +children+ - array of all immediate childrens
# * +all_children+ - array of all children and nested children
# * +full_set+ - array of itself and all children and nested children
#
  acts_as_fast_nested_set :parent_column => 'parent_id',
                     :left_column =>   'left_limit',
                     :right_column =>  'right_limit',
                     :scope => :name,
                     :text_column => 'title'
     
  validates_presence_of   :project_id
  validates_presence_of   :title
  validates_presence_of   :name


  has_many :references,  :class_name  =>'ProjectElement',  :foreign_key =>'reference_id',:dependent => :destroy
  has_many :elements,  :class_name  =>'ProjectElement',  :foreign_key =>'content_id',  :dependent => :destroy

##
# The textual information is linked into a number of folders
#   
  has_many :folders,:through    => :elements,    :source     => :content

  def html_urls
    urls = Array.new
    (body_html.to_s + extended_html.to_s).gsub(/<a [^>]*>/) do |tag|
      if(tag =~ /href="([^"]+)"/)
        urls.push($1)
      end
    end
    urls
  end


  def icon(options={} )
        '/images/mime/html.png'
  end
  
  def summary
     out = ' ' 
     out << title
     out << ' ['
     out << number_to_human_size( body_html.size)
     out << "]"  
  end
  
##
# calculate the signature of a record and return the result.
# This is a MD5 checksum of the current fields in the record
# 
  def signature(fields =  nil )
     fields ||= attributes.keys
     keys = attributes.keys - ['content_hash']
     data = keys.collect{|key| "#{key}:#{attributes[key]}"}.join(',')
     Digest::MD5.hexdigest(data )
  end


  # Rebuild all the set based on the parent_id and text_column name
  #
  def self.rebuild_sets
    roots.each{|root|root.rebuild_set}
  end
  #
  # Rebuild the tree for this scope
  #
  def rebuild_set(parent =nil)
    Content.transaction do    
      if parent.nil?
         self.left_limit = 1
         self.right_limit = 2         
         self.save
      end
      items = Content.find(:all, :conditions => ["name=? AND parent_id = ?",self.name, self.id],   :order => 'parent_id,name')                                       
      for child in items 
         add_child(child)             
      end  
      for child in items 
         child.rebuild_set(self)
      end  
    end
    self
 end
  
  # Adds a child to this object in the tree.  If this object hasn't been initialized,
  # it gets set up as a root node.  Otherwise, this method will update all of the
  # other elements in the tree and shift them to the right, keeping everything
  # balanced. 

  def add_child( child )   
    
    raise ActiveRecord::ActiveRecordError, "Adding sub-tree isn\'t currently supported"  if child.root?   
    raise ActiveRecord::ActiveRecordError, "Moving element to another sub-tree isn\'t currently supported" if child.parent_id  and child.parent_id != self.id  

    Content.transaction do    
      if ( self.left_limit == nil) || (self.right_limit == nil) 
          # Looks like we're now the root node!  Woo
          self.left_limit = 1
          self.right_limit = 2         
      end

      right_bound = self.right_limit
      # OK, we need to shift everything else to the right
      Content.update_all( "left_limit= left_limit + 2",  ["name = ? AND left_limit >= ?",   self.name,right_bound] )            
      Content.update_all( "right_limit = right_limit + 2",["name =? AND right_limit >= ?",  self.name,right_bound] )

      # OK, add child
      child.parent_id  = self.id
      child.left_limit = right_bound
      child.right_limit = right_bound + 1
      self.right_limit += 2
      self.save!                    
      child.save!
    end
  end      

end
