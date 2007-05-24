# == Schema Information
# Schema version: 239
#
# Table name: project_elements
#
#  id                 :integer(11)   not null, primary key
#  parent_id          :integer(11)   
#  project_id         :integer(11)   not null
#  type               :string(32)    default(ProjectElement)
#  position           :integer(11)   default(1)
#  name               :string(64)    default(), not null
#  path               :string(255)   default(), not null
#  reference_id       :integer(11)   
#  reference_type     :string(20)    
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# This represents a item in a folder. This could be a reference to a textual context, 
# a model or a file asset. The content and asset links are special sub types of the
# polymophic general model reference.
# 
# 
class ProjectElement < ActiveRecord::Base
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
# * +children_count+ - count of all immediate children
# * +children+ - array of all immediate childrens
# * +all_children+ - array of all children and nested children
# * +full_set+ - array of itself and all children and nested children
#
  acts_as_nested_set :parent_column => 'parent_id',
                     :left_column => 'left_limit',
                     :right_column => 'right_limit',
                     :scope => 'project_id',
                     :class => ProjectElement,
                     :text_column => 'name'

  acts_as_audited :change_log
  
  acts_as_ferret :fields => [ :name, :description, :path ], :single_index => true, :store_class_name => true

  acts_as_taggable 
  
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>[:project_id, :parent_id, :reference_type]
  validates_uniqueness_of :path
  validates_presence_of   :project_id
  validates_presence_of   :path
  validates_presence_of   :name
  validates_presence_of   :position
 

##
# Base reference to ownering project.
# project membership is used to goven access rights
#   
  belongs_to :project

##
#All references 
  belongs_to :reference, :polymorphic => true 
  belongs_to :asset,   :class_name =>'Asset',  :foreign_key => 'asset_id', :dependent => :destroy
  belongs_to :content, :class_name =>'Content', :foreign_key => 'content_id', :dependent => :destroy

  def before_validate
    ref = self.path
    self.path = parent.path + "/" + self.name
    if ref and ref != self.path
      log.info "path has changed #{ref} tp #{self.path}"
    end
  end

##
# Parent of a record is a   
  def folder
    parent
  end

  def asset?
    !(attributes['asset_id'].nil?)
  end
  
  def description
    return path
  end
##
# This has a content? entries
#  
  def textual?
    !(attributes['content_id'].nil?)
  end
##
# This has a reference entries 
#   
  def reference?
    !(attributes['reference_type'].nil?)
  end

  def icon( options={} )
     return '/images/model/note.png'
  end  
  
  def summary
     return path
  end
##
# Show the style of the project element
# 
  def style
    case attributes['reference_type']
    when 'ProjectElement': "link"
    when 'ProjectContent': "note"
    when 'ProjectAsset':   "file"
    when 'Study' :         "study"
    when 'StudyProtocol':  "protocol"
    when 'Experiment'      "experiment" 
    when 'Task':           "task"
    when 'Report' :        "report"
    else
       return 'asset' if asset?
       return 'content' if textual?
       return 'reference' if reference?
       return 'folder'
    end
  end
  

  
  def reorder_before(destination)
     logger.info "Move #{self.id} before #{destination.id}"
     if self.parent_id ==  destination.parent_id
       ProjectElement.transaction do
         self.move_to_left_of destination
       end
     end
  end


  # Rebuild all the set based on the parent_id and text_column name
  #
  def self.rebuild_sets
    roots.each{|root|root.rebuild_set}
  end
        
  def rebuild_set(parent =nil)
    ProjectElement.transaction do    
      if parent.nil?
         self.left_limit = 1
         self.right_limit = 2         
         self.save
      end
      items = ProjectElement.find(:all, :conditions => ["project_id=? AND parent_id = ?",self.project_id, self.id],   :order => 'parent_id,name')                                       
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

    ProjectElement.transaction do    
      if ( self.left_limit == nil) || (self.right_limit == nil) 
          # Looks like we're now the root node!  Woo
          self.left_limit = 1
          self.right_limit = 2         
      end

      right_bound = self.right_limit
      # OK, we need to shift everything else to the right
      ProjectElement.update_all( "left_limit= left_limit + 2",  ["project_id = ? AND left_limit >= ?",  self.project_id,right_bound] )            
      ProjectElement.update_all( "right_limit = right_limit + 2",["project_id =? AND right_limit >= ?",  self.project_id,right_bound] )

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
