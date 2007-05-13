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
  acts_as_tree :order => "position"  

  acts_as_audited :change_log
  acts_as_ferret :fields => [ :name, :description, :path ], :single_index => true, :store_class_name => true

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
  belongs_to :content, :class_name =>'ProjectContent', :foreign_key => 'content_id', :dependent => :destroy
##
# File assets  
  belongs_to :asset,   :class_name =>'ProjectAsset',  :foreign_key => 'asset_id', :dependent => :destroy
##
# Parent of a record is a   
  def folder
    parent
  end

  def asset?
    !(attributes['asset_id'].nil?)
  end
  
  def description
    return content.body_html if content
    return asset.title if asset
    return path
  end
##
# This has a textual? entries
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
     return asset.icon(options) if asset?
     return content.icon(options) if textual?
     return '/images/model/note.png'
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")
      '/images/model/file.png'
  end  
  
  def summary
     return asset.summary if asset
     return content.summary if content
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
     logger.info "Move #{self.id} before #{destination.id}"
     if self.parent_id ==  destination.parent_id
       ProjectElement.transaction do
         pos = destination.position 
         if destination.position > self.position
            ProjectElement.update_all("position=position-1"," parent_id=#{self.parent_id} and (position between  #{self.position+1} and #{destination.position}")    
         elsif destination.position < self.position
            ProjectElement.update_all("position=position+1"," parent_id=#{self.parent_id} and position between  #{destination.position} and #{self.position-1} ")        
         end 
         self.position = pos
         self.save
         end
     end
  end


  def reorder_before_code(destination)
     logger.info "Move #{self.id} before #{destination.id}"
     if self.parent_id ==  destination.parent_id
       ProjectElement.transaction do
         i=0
         for item in self.parent.elements.sort{|a,b|a.position<=>b.position}
           i += 1 
           if self.id == item.id
           elsif destination.id == item.id
              self.position = i 
              self.save
              i += 1
              item.position = i
              item.save
           else
              item.position =  i
              item.save
           end
         end 
       end
     end
  end


end
