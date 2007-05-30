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
# * +count+ - count of all immediate children
# * +children+ - array of all immediate childrens
# * +all_children+ - array of all children and nested children
# * +full_set+ - array of itself and all children and nested children
#
  acts_as_fast_nested_set :parent_column => 'parent_id',
                     :left_column => 'left_limit',
                     :right_column => 'right_limit',
                     :scope => :project_id,
                     :text_column => 'name'

  acts_as_audited :change_log
  
  acts_as_ferret :fields => [ :name, :description,:summary ], :single_index => true, :store_class_name => true

  acts_as_taggable 
  
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>[:project_id, :parent_id, :reference_type]
  validates_presence_of   :project_id
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

##
# Parent of a record is a   
  def folder
    parent
  end

  def asset?
    !(attributes['asset_id'].nil?)
  end
  
  def path
    root= self.self_and_ancestors.collect{|i|i.name}
    root[0]='.'
    root.join('/')
  end
  
  def description
    return name
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

  def title
     return name
  end  

  def summary
     return name
  end

  def to_html
     return name
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
       return "#{reference_type}" if reference?
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
    roots.each do |root|
      root.left_limit = 1
      root.right_limit = 2 
      root.save!
      root.rebuild_set
    end
    roots.size
  end
        
  def rebuild_set
    ProjectElement.transaction do    
      items = ProjectElement.find(:all, :conditions => ["project_id=? AND parent_id = ?",self.project_id, self.id],:order => 'parent_id,id')                                       
      for child in items 
         self.add_child(child)             
      end  
      for child in items 
         child.rebuild_set
      end  
    end
    child_count
 end
  
 
        
end
