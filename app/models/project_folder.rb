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
require 'pathname'
class ProjectFolder < ProjectElement

  cattr_accessor :current
##
# Details of the order
#   Checking studies
  has_many :elements,  :class_name  => 'ProjectElement',
                       :foreign_key => 'parent_id',
                       :include => [:asset,:content],
                       :order       => 'project_elements.left_limit'  

  def assets(limit=100)
    ProjectAsset.find(:all,:conditions=>['project_elements.parent_id=? ',self.id],:include => [:asset],:order=>'project_elements.updated_at desc',:limit=>limit) 
  end

  def contents(limit=100)
    ProjectContent.find(:all,:conditions=>['project_elements.parent_id=? ',self.id],:include => [:content],:order=>'project_elements.updated_at desc',:limit=>limit) 
  end

  def title 
    if reference and reference.respond_to?(:name)
      out = " #{self.reference_type} ["
      out << self.reference.name 
      out << "] "
      return out
    end
    return self.name
  end

  def summary
    return "#{self.style.capitalize} folder with #{self.child_count} items"   if reference 
    return "#{self.style.capitalize} with #{self.child_count} items"     
  end

  def description
    if reference and reference.respond_to?(:description)
      return self.reference.description 
    end
    return name
  end

  def to_html
    if reference
      return reference.to_html if reference.respond_to?(:to_html)
      out = "<h4> #{self.reference_type} ["
      out << self.reference.name if reference.respond_to?(:description)
      out << "] </h4><p>"
      out << self.reference.description if reference.respond_to?(:description)
      out << "</p>"
      return out
    end
    return path
  end
  
  
  def icon( options={} )
     case attributes['reference_type']
      when 'Project' :        return '/images/model/project.png'
      when 'Study' :          return '/images/model/study.png'
      when 'StudyParameter':  return '/images/model/parameter.png'
      when 'StudyProtocol':   return '/images/model/protocol.png'
      when 'Experiment':      return '/images/model/experiment.png'
      when 'Task':            return '/images/model/task.png'
      when 'Report':          return '/images/model/report.png'
      when 'Request':         return '/images/model/request.png'
      when 'Compound':        return '/images/model/compound.png'
      else
         return '/images/model/folder.png'
      end 
  end    

#
#
#
 def copy(item)
   element = item.clone
   element.reference=item
   element.parent= self
   logger.info "cloned element ==============================================="
   logger.info element.to_yaml
   element.project_id = self.project_id
   element.position = self.elements.size
   element.parent_id = self.id
   return element unless element.valid?
   element.save
   element.move_to_child_of(self)        
   return element
 end
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
       element = item
       case item
       when ProjectAsset,ProjectContent,ProjectFolder,ProjectElement
           element = item           
       when String 
           element.name = "comment-#{self.child_count}"
           element = ProjectContent.Build(:project_id=> self.project_id,:parent=>self, :name=>name, :title=>"comments",:body=>item )
       else    
           name = (item.respond_to?(:name) ? item.name : item.to_s )
           return add_reference( name, item ) 
       end       
       element.project_id = self.project_id
       element.position = self.elements.size
       element.parent_id = self.id
       unless element.valid?
         logger.error("Failed to save element in add(#{item.path}) "+ element.errors.full_messages.to_sentence)
       else    
         element.save
         self.add_child(element)     
       end
       return element
     end       
  end
  
#
# Add a encoded files as a Base64 text string
#
#
  def add_asset( filepath, title =nil, mime_type = 'image/jpeg', data =nil )
     logger.info "add_asset(#{filepath}, #{title}, #{mime_type})"
     ProjectElement.transaction do 
       filename = File.basename(filepath)
       title ||= filename
       element   = self.elements.find_by_name(filename)
       element ||= ProjectAsset.new(:parent_id=>self.id, :name=> filename, :project_id=> self.project_id)
       asset = Asset.new(:title=>title, :filename=> filename, :project_id=> self.project_id,:content_type => mime_type)
       asset.size =0
       if data
         asset.temp_data = data
       else
         asset.temp_path = filepath
       end
       asset.save 
       element.asset = asset
       element.asset_id = asset.id
       if element.new_record?
            self.add(element) 
       else
            element.save
       end
       return element
     end
     return nil
  end
##
# Add a reference to the another database model
#   
  def add_reference(name,item)
     logger.info "add_reference(#{name}, #{item.class}:#{item.id})"
     ProjectElement.transaction do 
         element = ProjectReference.new(:name=> name, :parent_id=>self.id, :project_id => self.project_id )                                       
         element.reference = item    
         case item
         when ProjectContent
           element.content_id = item.content_id
         when ProjectAsset
           element.asset_id = item.asset_id
         end
         return add(element)
     end
  end
  
  def add_content(name,title,body)
     logger.info "add_reference(#{name}, #{title})"
     ProjectElement.transaction do 
         element = ProjectContent.build(:name=> name, 
                                      :title=> title,
                                      :position => elements.size,
                                      :parent=>self,
                                      :title=> title,
                                      :to_html => body,
                                      :project_id=>self.project_id)
           return add(element)
     end
     return nil
  end

##
# Get a elment in the folder 
#                        
   def get(item)
      return self if item == self
      if item.is_a?  ActiveRecord::Base
         ProjectElement.find(:first,:conditions=>['parent_id=? and reference_type=? and reference_id=?',self.id,item.class.to_s,item.id])
      elsif item.respond_to?(:name)
         ProjectElement.find(:first,:conditions=>['parent_id=? and name=?',self.id,item.name.to_s])
      else
         ProjectElement.find(:first,:conditions=>['parent_id=? and name=?',self.id,item.to_s])
      end
   end

##
# Get a root folder my name 
# 
  def folder?(item)
    return self if item == self
    if item.is_a?  ActiveRecord::Base
       ProjectFolder.find(:first,:conditions=>['parent_id=? and reference_type=? and reference_id=?',self.id,item.class.to_s,item.id])
    elsif item.respond_to?(:name)
       ProjectFolder.find(:first,:conditions=>['parent_id=? and name=?',self.id,item.name.to_s])
    else
       ProjectFolder.find(:first,:conditions=>['parent_id=? and name=?',self.id,item.to_s])
    end
 
  end  

  
##
# add/find a folder to the project. This  
# 
  def folder(item)
    folder = self.folder?(item)
    if folder.nil? 
       logger.info "Creating folder #{name}"
       if item.respond_to?(:name)
          folder = ProjectFolder.new(:name=> item.name, 
                                     :position => self.elements.size, 
                                     :parent_id=>self.id, 
                                     :project_id => self.project.id ) 
          folder.reference =  item         
       else
          folder = ProjectFolder.new(:name=> item.to_s, 
                                     :position => self.elements.size, 
                                     :parent_id=>self.id, 
                                     :project_id => self.project.id ) 
       end
       self.add(folder )   
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
#
# Helper to return the current active project 
# 
  def self.current
    @current || Project.current.folder
  end
  
end
