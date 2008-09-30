# == Schema Information
# Schema version: 359
#
# Table name: project_elements
#
#  id                     :integer(4)      not null, primary key
#  parent_id              :integer(4)
#  project_id             :integer(4)      not null
#  type                   :string(32)      default("ProjectElement")
#  position               :integer(4)      default(1)
#  name                   :string(64)      default(""), not null
#  reference_id           :integer(4)
#  reference_type         :string(20)
#  lock_version           :integer(4)      default(0), not null
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  updated_by_user_id     :integer(4)      default(1), not null
#  created_by_user_id     :integer(4)      default(1), not null
#  asset_id               :integer(4)
#  content_id             :integer(4)
#  project_elements_count :integer(4)      default(0), not null
#  left_limit             :integer(4)      default(1), not null
#  right_limit            :integer(4)      default(2), not null
#  state_id               :integer(4)
#  element_type_id        :integer(4)
#  title                  :string(255)
#  access_control_list_id :integer(4)
#

# == Description
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
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
require 'ftools'

class ProjectFolder < ProjectElement

  cattr_accessor :current
##
# Details of the order
#   Checking assays

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

  #
  # Summary text for a the folder content
  #
  def summary    
#    if self.published?
#        text = "Published " 
#    elsif self.signed?
#        text = "Signed " 
#    else  
        text = ""
#    end
    text << " #{self.style.capitalize} "
    text << " folder " if self.reference_id
    text << " with #{self.all_children_count} items "
    return text
  end

  
  def icon( options={} )
     case attributes['reference_type']
      when 'Project'  then        return '/images/model/project.png'
      when 'Assay'  then          return '/images/model/assay.png'
      when 'AssayParameter' then  return '/images/model/parameter.png'
      when 'AssayProtocol' then   return '/images/model/protocol.png'
      when 'Experiment' then      return '/images/model/experiment.png'
      when 'Task' then            return '/images/model/task.png'
      when 'Report' then          return '/images/model/report.png'
      when 'Request' then         return '/images/model/request.png'
      when 'Compound' then        return '/images/model/compound.png'
      else
         return '/images/model/folder.png'
      end 
  end    

#
# Copy the passed element under this one
#
 def copy(item)
   element = item.clone
   element.reference=item
   element.parent= self
   logger.debug "cloned element ==============================================="
   logger.debug element.to_yaml
   element.project_id = self.project_id
   element.position = self.elements.size
   element.parent_id = self.id
   return element unless element.valid?
   self.add_child(element)
   return element
 end
  
  def self.add_root(project)
    ProjectFolder.create({
           :name =>project.name,
           :title =>project.title,
           :reference => project,
           :project => project,
           :state_id => 1,
           :access_control_list => AccessControlList.from_team(project.team)
   })
  end
  #
  # Add a link to another project element with possible of setting the owner
  #
  def add_link(from,owner_id=nil)
    raise "No right to add to distination" unless self.allow?(:data,:create)    
    if from.is_a?(ProjectElement)
       raise "No right to update source" unless from.allow?(:data,:update)
       add_element(ElementType::REFERENCE,{
           :name =>from.name,
           :title =>from.title,
           :reference => from.reference,
           :access_control_list_id => from.access_control_list_id,
         })
    end 
  end  
  #
  # Make a html file copy all assets and html to folder_filepath
  #
  def make_htmlfile(filename)
    logger.info("Making HTML #{filename}") 
    open(File.join(filename),'w') do |file|
       file << "<h2>#{project.name}</h2>"
       serialize_to_html(file,self)
       file.flush
    end            
  end

#
# generate a PDF for the current element
#
  def make_pdf(filename)
    logger.info("Making PDF #{filename}")

    html_filename = File.join(folder_filepath,'folder.html')

    self.make_htmlfile(html_filename)
      pdf = PDF::HTMLDoc.new
      pdf.set_option :outfile, filename
      pdf.set_option :outfile, filename
      pdf.set_option :webpage, true
      pdf.set_option :charset, SystemSetting.character_set
      pdf.set_option :bodycolor, :white
      pdf.set_option :links, false
      pdf.set_option :path, File::SEPARATOR
      pdf << html_filename
      pdf.generate
     return pdf
  end
  #
  # Get the root project filepath
  #
  def project_filepath
    unless @project_filepath
      @project_filepath = File.join(RAILS_ROOT,"public",SystemSetting.published_folder,project.dom_id)
      File.makedirs(@project_filepath)
    end
    @project_filepath
  end
  #
  # Get the folder path for the current folder on the public file space 
  #
  def folder_filepath
    unless @folder_filepath
      @folder_filepath = File.join(self.project_filepath,self.dom_id)
      File.makedirs(@folder_filepath)
    end
    @folder_filepath
  end
  
#
# Helper to return the current active project 
# 
  def self.current
    @current || Project.current.home
  end
  
    
protected
  #
  # Serialize the current item out as html copying all asset to folder
  #
  def serialize_to_html(file,current_item)
    logger.info("#{current_item.dom_id} #{current_item.name} converted to html ")
    
    doc = Biorails.utf8_to_codepage(current_item.to_html)
    doc = doc.gsub(/src='\/project_assets\/[0-9]*\/[0-9]*\//,"src='")    
    if current_item.asset
      path ="public"+ current_item.asset.public_filename(self.default_image_size)
      logger.info "cp #{path},#{folder_filepath}"
      FileUtils.cp path, folder_filepath      
    end   
    file << doc
    current_item.children.each do |child|
      file << "<div class='box'>" 
      child.default_image_size = self.default_image_size
      serialize_to_html(file,child)
      file << "</div>" 
    end
  end
       
end
