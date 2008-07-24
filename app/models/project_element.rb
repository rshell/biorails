# == Schema Information
# Schema version: 306
#
# Table name: project_elements
#
#  id                     :integer(11)   not null, primary key
#  parent_id              :integer(11)   
#  project_id             :integer(11)   not null
#  type                   :string(32)    default(ProjectElement)
#  position               :integer(11)   default(1)
#  name                   :string(64)    default(), not null
#  reference_id           :integer(11)   
#  reference_type         :string(20)    
#  lock_version           :integer(11)   default(0), not null
#  created_at             :datetime      not null
#  updated_at             :datetime      not null
#  updated_by_user_id     :integer(11)   default(1), not null
#  created_by_user_id     :integer(11)   default(1), not null
#  asset_id               :integer(11)   
#  content_id             :integer(11)   
#  published_hash         :string(255)   
#  project_elements_count :integer(11)   default(0), not null
#  left_limit             :integer(11)   default(1), not null
#  right_limit            :integer(11)   default(2), not null
#  team_id                :integer(11)   default(0), not null
#  published_version_no   :integer(11)   default(0), not null
#  version_no             :integer(11)   default(0), not null
#  previous_version       :integer(11)   default(0), not null
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
                     :order => 'project_id,left_limit',
                     :scope => :project_id,
                     :text_column => 'name'

  acts_as_audited :change_log
  
  acts_as_ferret :fields => [ :name, :title, :summary, :description], :default_field=>[:name], :single_index => true, :store_class_name => true
  
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>[:project_id, :parent_id, :reference_type]
  validates_presence_of   :project_id
  validates_presence_of   :name
  validates_presence_of   :position
 

  attr_accessor :default_image_size
##
# Base reference to ownering project.
# project membership is used to goven access rights
#   
  belongs_to :project
#
# access control managed via team
# 
  access_control_via  :team  
##
#All references 
  belongs_to :reference, :polymorphic => true 
  belongs_to :asset,   :class_name =>'Asset',  :foreign_key => 'asset_id', :dependent => :destroy
  belongs_to :content, :class_name =>'Content', :foreign_key => 'content_id', :dependent => :destroy

  has_many :signatures, :order=> 'id desc',:dependent => :destroy
    
#
# make sure project and team are set
# 
  def before_create 
    if self.parent
      self.project ||= self.parent.project         
      self.team ||= self.parent.team
    end
    self.project ||= Project.current          
    self.team ||= Team.current
  end 


  def asset?
    !(attributes['asset_id'].nil?)
  end

  def path(prefix = nil)
    root= self.self_and_ancestors.collect{|i|i.name}
    root[0]=prefix if prefix
    root.join('/')
  end
  
  def description
    return name
  end

  #
  # Items are regarded as published if they have a published_hash reflexing a signed document
  #
  def published?
    !self.signatures.find( :first , :conditions=> ['signature_state=? and signature_role= ?', 'SIGNED','WITNESS'] ).nil?
  end
  #
  # There is a signature with the element
  #
  def signed?
    self.signatures.exists?( ['signature_state=?', 'SIGNED'] )
  end

 def signed(limit=5)
    self.signatures.find( :all , :conditions=> ['signature_state=?', 'SIGNED'],:limit=>limit )
 end

 def image_tag
   if self.asset
     self.asset.image_tag(default_image_size,600)
   else
     ""     
   end
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

##
# Summay of the content

  def summary
     return self.content.summary if content
     return self.asset.summary if asset
     return self.title  unless self.title.blank?
     name
  end

  def url
   self.asset.public_filename  if self.asset
  end
##
# Show the style of the project element
# 
  def style
    if attributes['reference_type']
      case attributes['reference_type']
      when 'ProjectElement' then "link"
      when 'ProjectContent' then "note"
      when 'ProjectAsset' then   "file"
      when 'AssayProtocol' then  "protocol"
      else
       attributes['reference_type'].downcase
      end
    else
      return 'asset' if  self.asset? 
      return 'content' if  self.textual?
     'folder'
    end
  end
  
#
# todo get position working via a RANK now easy in mysql
#
# select * , 
#        (select 1+count(*) from project_elements b where parent_id=5 and b.left_limit < a.left_limit) rank
#from project_elements a where parent_id=5 order by left_limit
#
#
  
  def reorder_before(destination)
     logger.info "Move #{self.id} before #{destination.id}"
     if self.parent_id ==  destination.parent_id
       ProjectElement.transaction do
         self.move_to_left_of destination
   
       end
     end
  end

  def reorder_after(destination)
     logger.info "Move #{self.id} before #{destination.id}"
     if self.parent_id ==  destination.parent_id
       ProjectElement.transaction do
         self.move_to_right_of destination   
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
  
 def ancestors
    (self.content ? self.content.ancestors : [])
 end

   def to_liquid
    ProjectElementDrop.new self
  end 

end
