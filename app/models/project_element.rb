# == Schema Information
# Schema version: 233
#
# Table name: project_elements
#
#  id                :integer(11)   not null, primary key
#  type              :string(20)    
#  project_id        :integer(11)   not null
#  project_folder_id :integer(11)   not null
#  position          :integer(11)   default(1)
#  reference_id      :integer(11)   not null
#  reference_type    :string(20)    
#

##
# This represents a item in a folder. This could be a reference to a textual context, 
# a model or a file asset. The content and asset links are special sub types of the
# polymophic general model reference.
# 
# 
class ProjectElement < ActiveRecord::Base

  attr_accessor :tags
  
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>[:project_id, :parent_id, :reference_type]
  validates_uniqueness_of :path
  validates_presence_of   :name
 
  acts_as_tree :order => "position"  
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
  belongs_to :content, :class_name =>'ProjectContent', :foreign_key => 'reference_id'
##
# File assets  
  belongs_to :asset,   :class_name =>'ProjectAsset',  :foreign_key => 'reference_id'
##
# Parent of a record is a   
  def folder
    parent
  end

  def asset?
    attributes['reference_type'] == 'ProjectAsset'
  end
##
# This has a textual? entries
#  
  def textual?
    attributes['reference_type'] == 'ProjectContent'
  end
##
# This has a reference entries 
#   
  def reference?
    !(attributes['reference_type'].nil? or textual? or asset?)
  end
  
##
# Show the style of the project element
# 
  def style
    case attributes['reference_type']
    when 'ProjectContent'
      "note"
    when 'ProjectAsset'
      "file"
    when 'Study'
      "study"
    when 'Experiment'
      "experiment"
    when 'Task'
      "task"
    when 'StudyProtocol'
      "protocol"
    when nil 
      "folder"  
    else
      attributes['reference_type']
    end
  end
  
end
