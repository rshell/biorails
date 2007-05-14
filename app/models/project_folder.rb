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
class ProjectFolder < ProjectElement
##
# Details of the order
#   Checking studies
  has_many :elements,  :class_name  => 'ProjectElement',
                       :foreign_key => 'parent_id',
                       :include => [:asset,:content],
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
           element = add_reference( item.title, item )        
           element.asset_id = item.id
           return element       

       when ProjectContent
           element =add_reference( item.name ,item )  
           element.content_id = item.id
           return element       

       when ProjectFolder
           element =add_reference( item.name ,item )  
           element.content_id = item.content_id
           element.asset_id = item.asset_id
           return element       

       when ProjectElement
           element =add_reference( item.name ,item )  
           element.content_id = item.content_id
           element.asset_id = item.asset_id
           return element       

       when String 
           name = "comment-#{self.children.size}"
           content = ProjectContent.new(:project_id=> self.project_id, :name=>name, :title=>"comments",:body=>item )
           content.save
           return add_reference( name, content )
       else    
           name = (item.respond_to?(:name) ? item.name : item.to_s )
           return add_reference( name, item ) 
       end       
     end       
  end
  
  def add_file(filename, title =nil, content_type = 'image/jpeg')
     ProjectFolder.transaction do 
         title ||= filename
         asset = ProjectAsset.new(:title=>title, :filename=> filename, :project_id=>self.project_id)
         asset.temp_path = filename
         asset.content_type = content_type 
         if asset.save
           element = get(filename)
           element ||= ProjectElement.new(:name=> asset.filename, :position => self.children.size,   :parent_id=>self.id, :project_id => self.project_id )                                       
           element.path = self.path + "/" + asset.filename
           element.asset = asset
           element.save
           return element
         end
     end    
     return nil
  end
##
# Add a reference to the another database model
#   
  def add_reference(name,item)
     ProjectFolder.transaction do 
         element = ProjectElement.new(:name=> name, :position => self.children.size, :parent_id=>self.id, :project_id => self.project_id )                                       
         element.path = self.path + "/" + name
         element.reference = item       
         element.save
         return element
     end
  end

  def add_asset(name,asset)
     ProjectFolder.transaction do 
         element = get(name)     
         element ||= ProjectElement.new(:name=> name, :position => self.children.size, :parent_id=>self.id, :project_id => self.project_id )                                       
         element.path = self.path + "/" + name
         element.asset = asset
         element.save
         return element
     end
  end
  
  
  def add_content(name,title,body)
     ProjectFolder.transaction do 
         content = ProjectContent.new(:name=> name, :title=> title, :body_html=>body,:project_id=>self.project_id)
         content.save
         element = get(name)     
         element ||= ProjectElement.new(:name=> name, :position => self.children.size, :position => elements.size,
                                       :parent_id=>self.id, :project_id => self.project_id )                                       
         element.path = self.path + "/" + name
         element.content = content
         element.save
         return element
     end
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
  
  def summary
     return "folder of #{elements.size} items"
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
          folder.path = self.path + "/" + item.name
       else
          folder = ProjectFolder.new(:name=> item.to_s, 
                                     :position => self.elements.size, 
                                     :parent_id=>self.id, 
                                     :project_id => self.project.id ) 
          folder.path = self.path + "/" + item.to_s
       end
       self.elements << folder    
       folder.save
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
