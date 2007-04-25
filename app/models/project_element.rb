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
  acts_as_audited :change_log

  acts_as_tree :order => "position"  
  
  acts_as_taggable 
  
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>[:project_id, :parent_id, :reference_type]
  validates_uniqueness_of :path
  validates_presence_of   :name
 

##
# Base reference to ownering project.
# project membership is used to goven access rights
#   
  belongs_to :project
##
#All references 
  belongs_to :reference, :polymorphic => true
##
# Textual content  
  belongs_to :content, :class_name =>'ProjectContent', :foreign_key => 'content_id'
##
# File assets  
  belongs_to :asset,   :class_name =>'ProjectAsset',  :foreign_key => 'asset_id'
##
# Parent of a record is a   
  def folder
    parent
  end

  def asset?
    !self.asset_id.nil? 
  end
##
# This has a textual? entries
#  
  def textual?
    !self.content_id.nil?
  end
##
# This has a reference entries 
#   
  def reference?
    !(attributes['reference_type'].nil?)
  end

  def icon( options={} )
     return asset.icon(options) if asset?
     return content.icon(options) if textual?
     return '/images/model/note.png'
  end  
  
  def summary
     return asset.summary if asset?
     return content.summary if textual?
     return path
  end
##
# Show the style of the project element
# 
  def style
    case attributes['reference_type']
    when 'ProjectContent': "note"
    when 'ProjectAsset':   "file"
    when 'Study' :         "study"
    when 'Experiment'      "experiment" 
    when 'Task':           "task"
    when 'Report' :        "report"
    when 'StudyProtocol':  "protocol"
    when nil :             "folder"  
    else
      "link_go"
    end
  end
  
  
  def reorder_before(destination)
     if self.parent_id ==  destination.parent_id
       ProjectElement.transaction do
         pos = destination.position 
         if destination.position > self.position
            ProjectElement.update_all("position=position-1",
             " parent_id=#{self.parent_id} and id between #{self.id+1} and #{destination.id}")    
         else
            ProjectElement.update_all("position=position+1",
             " parent_id=#{self.parent_id} and id between  #{destination.id} and #{self.id-1} ")        
         end 
         self.position = pos
         self.save
         end
     end
  end
end
