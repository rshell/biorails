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
  

end
