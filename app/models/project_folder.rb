# == Schema Information
# Schema version: 233
#
# Table name: project_folders
#
#  id             :integer(11)   not null, primary key
#  project_id     :integer(11)   not null
#  parent_id      :integer(11)   
#  folder_type    :string(20)    
#  position       :integer(11)   default(1)
#  name           :string(255)   default(), not null
#  description    :string(255)   
#  reference_id   :integer(11)   not null
#  reference_type :string(20)    
#  path           :string(255)   default(), not null
#  layout         :string(255)   
#  template       :string(255)   
#  element_count  :integer(11)   default(0)
#  lock_version   :integer(11)   default(0), not null
#  created_by     :string(32)    default(sys), not null
#  created_at     :datetime      not null
#  updated_by     :string(32)    default(sys), not null
#  updated_at     :datetime      not null
#  published_at   :datetime      
#  published_by   :string(255)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#

##
# This is a folder of information in the scope of the project. The may be either a 
# standalone folder or linked to a model via a polymorphic reference. Folders 
# are all linked to the project as held in a tree with a root referenced back to 
# project
# 
# For a number of model types sub folders are created linked to the model to allow
# for unstructured data capture agained the base model. This is used to add the ability
# to add textual notes/comments and file/image based assets to the model object.
# 
# The data represented in a folder may be displayed in a number of formats:-
# 
#  * Blogs reverse time ordered items
#  * Document html component document based on recurive tree
#  * Folder directory style view
#  * Page of all items in the folder in order 
# 
class ProjectFolder < ActiveRecord::Base
 
  acts_as_tree :order => "name"  
##
# Base reference to ownering project.
# project membership is used to goven access rights
#   
  belongs_to :project
##
#All references 
  belongs_to :reference, :polymorphic => true
##
# Details of the order
#   
  has_many :elements,  :class_name  =>'ProjectElement',
                       :foreign_key =>'project_folder_id',
                       :order       => 'position'
##
#Link through to asset
#
  has_many :files, :through    => :elements, 
                   :source     => :assert,
                   :conditions => "elements.reference_type = 'ProjectAsset'"
##
#Link through to pages
#
  has_many :pages, :through    => :elements, 
                   :source     => :content,
                   :conditions => "elements.reference_type = 'ProjectContent'"
  
   
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>[:project_id, :parent_id, :reference_type]
  validates_uniqueness_of :path
  validates_presence_of   :name

##
# Add a file to the folder. This accepts a filename string of a assert 
# and create reference to it in the folder
#
# Support type of item for entry into a folder:-
#  
#  * String filename
#  * Object model
#  * ProjectContent
#  * ProjectAsset
# 
  def add(item)
     ProjectFolder.transaction do 
       element = self.elements.build(:project_folder_id=>self,
                                     :position => elements.size, 
                                     :project_id => self.project )                                      
       case item
       when String
           asset = ProjectAsset.new(:project_id => self.project_id, 
                                    :name => filename, 
                                    :title => filename  )
           asset.save       
           element.reference = asset
       else    
           element.reference = item
       end       
       element.save
       element
     end
  end

##
# Add some textual content to the system 
#  
  def add_text(title,excerpt,body)
     ProjectFolder.transaction do 
       content = ProjectContent.new(:project_id=> self.project_id, 
                                    :name=>title, 
                                    :title=>title, 
                                    :excerpt=>excerpt, 
                                    :body=>body )
       content.save
       element = ProjectElement.create(:project_folder_id=>self,
                                    :position => elements.size,
                                    :reference_id => content.id,
                                    :reference_type => content.class.to_s, 
                                    :project_id => self.project ) 
       element
     end
  end

end
