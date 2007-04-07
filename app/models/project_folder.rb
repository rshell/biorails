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
class ProjectFolder < ProjectElement
##
# Details of the order
#   
  has_many :elements,  :class_name  => 'ProjectElement',
                       :foreign_key => 'parent_id',
                       :order       => 'position'  
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
     ProjectElement.transaction do          
       case item
       when ProjectAsset
           add_reference( item.filename, item )        
       when String 
           name = "comment-#{children.size}"
           content = ProjectContent.new(:project_id=> self.project_id, :name=>name, :title=>"comments",:body=>item )
           content.save
           add_reference( name, content )
       else    
           name = (item.respond_to?(:name) ? item.name : item.to_s )
           add_reference( name, item ) 
       end       
     end       
  end
##
# Add a reference to the another database model
#   
  def add_reference(name,item)
     ProjectFolder.transaction do 
         element = ProjectElement.new(:name=> name, :position => children.size, :position => elements.size,:parent_id=>self.id, :project_id => self.project.id )                                       
         element.path = self.path + "/" + name
         element.reference = item
         element.save
         return element
     end
  end
##
# Get a root folder my name 
# 
  def folder?(item)
     return self if item == self
     item = item.name if item.is_a?  ActiveRecord::Base
     ProjectFolder.find(:first,:conditions=>['parent_id=? and name=?',self.id,item.to_s])
  end  
  
##
# add/find a folder to the project. This  
# 
  def folder(name)
    folder = folder?(name)
    if folder.nil? 
       logger.info "Creating folder #{name}"
       folder = ProjectFolder.new(:name=> name, :position => children.size, :position => elements.size,:parent_id=>self.id, :project_id => self.project.id ) 
       folder.path = self.path + "/" + name
       children << folder    
    end
    return folder
  end
##
# Get the lastest entries in the folder
#  
  def lastest( option={})
      query_options = { :conditions=>['parent_id=?',self.id],:order=>"updated_at desc",:limit=>10}      
      ProjectElement.find(:all,query_options.merge(option))
  end

end
