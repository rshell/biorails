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
require 'open_office'

class ProjectFolder < ProjectElement

  cattr_accessor :current
 
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
    text = ""
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
    ProjectFolder.transaction do
      raise ActiveRecord::ActiveRecordError, "Failed to added child as parent not saved: "+self.errors.full_messages().join("\n") if (self.new_record? and !self.save)
      raise ActiveRecord::ActiveRecordError, "This folder is not changeable"  unless self.changeable?
      element =nil
      if item.reference
        element = ProjectReference.new(:name=>item.name,:title=>item.title,:state_id=>item.state_id,:element_type => item.element_type)
        element.reference= item.reference
      else
        element = item.clone
        element.reference= item
      end
      element.parent= self
      element.state = self.state
      element.project_id = self.project_id
      element.position = self.elements.size
      element.parent_id = self.id
      return element unless element.valid?
      self.add_child(element)
      return element
    end
  end
  
  def self.add_root(project)
    ProjectFolder.transaction do
      ProjectFolder.create({
          :name =>project.name,
          :title =>project.title,
          :reference => project,
          :state_id => State.find(:first).id,
          :project => project,
          :element_type_id => 4,
          :access_control_list => AccessControlList.from_team(project.team)
        })
    end
  end
  #
  # Add a link to another project element with possible of setting the owner
  #
  def add_link(from,options={})
    ProjectFolder.transaction do
      raise "No right to add to destination" unless self.right?(:data,:create)
      if from.is_a?(ProjectElement)
        raise "No right to update source" unless from.right?(:data,:update)
        add_element(ElementType::REFERENCE,{
            :name =>from.name,
            :title => options[:title] || from.title,
            :reference => from.reference,
            :access_control_list_id => from.access_control_list_id,
          })
      else
        add_element(ElementType::REFERENCE,{
            :name =>from.name,
            :title => options[:title] ||from.name,
            :reference => from,
            :access_control_list_id => self.access_control_list_id,
          })
      end
    end 
  end
  #
  # List of Linked Items
  #  * model class to link to
  #  * return list of linked items of this class
  #
  def linked(klass)
    find_within(:all,:conditions=>['reference_type=?',klass.to_s],:order=>'parent_id,name')
  end
  #
  # List of Linked Items
  #  * model class to link to
  #  * return list of linked items of this class
  #
  def linked_objects(klass)
    items = linked(klass)
    items.collect{|i|i.reference}
  end
  #
  # List of Linked Items
  #  * model class to link to
  #  * return boolean true == destoried
  #
  def remove_link(object)
    if (object)
      item = find_within(:first,:conditions=>['reference_type=? and reference_id = ?',object.class.to_s,object.id])
      item.destroy if item
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

  def make_pdf(filename)
    logger.info("Making PDF #{filename}")
    outfile = convert_to("pdf")
    FileUtils.mv(outfile, filename) if outfile
  end
#
# generate a PDF for the current element
#
  def convert_to(format)
    html_filename = File.join(folder_filepath,'folder.html')
    self.make_htmlfile(html_filename)
    return nil unless  Alces::OpenOffice::FormatConverter.format?(format)
    formatter = Alces::OpenOffice::FormatConverter.new(format)
    output_file = formatter.convert(html_filename)   
    formatter.errors.each {|error| self.errors.add_to_base(error)}
    return output_file
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
