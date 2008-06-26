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
  

  def before_save
    @paths=[]
    @signable_document="<h2>"<< name << "</h2>"
    #get_assets(self)
    #self.published_hash=Signature.generate_checksum(@signable_document)
  end

  def assets(limit=100)
    ProjectAsset.find(:all,:conditions=>['project_elements.parent_id=? ',self.id],:include => [:asset],:order=>'project_elements.updated_at desc',:limit=>limit) 
  end

  def contents(limit=100)
    ProjectContent.find(:all,:conditions=>['project_elements.parent_id=? ',self.id],:include => [:content],:order=>'project_elements.updated_at desc',:limit=>limit) 
  end
  #
  # short title for the folder
  #
  def title 
    if reference and reference.respond_to?(:name)
      out = " #{self.reference_type} ["
      out << self.reference.name 
      out << "] "
      return out
    end
    return self.name
  end
  
  #
  # Summary text for a the folder content
  #
  def summary    
    if self.published?
        text = "Published " 
    elsif self.signed?
        text = "Signed " 
    else  
        text = ""
    end
    text << " #{self.style.capitalize} "
    text << " folder " if self.reference_id
    text << " with #{self.child_count} items "
    return text
  end

  def description
    if reference and reference.respond_to?(:description)
      return self.reference.description 
    end
    return name
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
  def add(element)
     ProjectElement.transaction do          
       element.project_id = self.project_id || Project.current.id
       element.position = self.elements.size
       element.parent_id = self.id
       element.team_id ||= self.team_id
       unless element.valid?
         logger.error("Failed to save element in add(#{element.path}) "+ element.errors.full_messages.to_sentence)
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
     ProjectElement.transaction do 
       logger.info "add_asset(#{filepath}, #{title}, #{mime_type})"
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
       ( element.new_record? ? self.add(element) : element.save )
       return element
     end
  end
##
# Add a reference to the another database model
#   
  def add_reference(name,item)
     ProjectElement.transaction do 
         logger.info "add_reference(#{name}, #{item.class}:#{item.id})"
         element = ProjectReference.new(:name=> name, :parent_id=>self.id, :project_id => self.project_id )                                       
         element.reference = item    
         if item.is_a?(ProjectElement)
           element.content_id = item.content_id 
           element.asset_id = item.asset_id
         end
         return add(element)
     end
  end
  
  def add_content(name,title,body)
     ProjectElement.transaction do 
         logger.info "add_reference(#{name}, #{title})"
         element = ProjectContent.build(:name=> name, 
                                      :title=> title,
                                      :position => elements.size,
                                      :parent=>self,
                                      :title=> title,
                                      :body_html => body,
                                      :project_id=>self.project_id)
           return add(element)
     end
  end

##
# Get a root folder my name 
# 
  def folder?(item)
    return self if item == self
    if item.is_a?  ActiveRecord::Base
       ProjectFolder.find(:first,:conditions=>['parent_id=? and reference_type=? and reference_id=?',self.id,item.class.class_name,item.id])
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
                                     :team_id => self.team_id,
                                     :project_id => self.project_id ) 
          folder.reference =  item         
       else
          folder = ProjectFolder.new(:name=> item.to_s, 
                                     :position => self.elements.size, 
                                     :parent_id=>self.id, 
                                     :team_id => self.team_id,
                                     :project_id => self.project_id ) 
       end
       self.add(folder )   
    end
    return folder
  end
  
  def new_published_version
    #increment the published version counter for the folder, and return the current number
    v=published_version_no+1
    update_attribute(:published_version_no,v )
    return v
  end
  #
  # Serialize the current item out as html copying all asset to folder
  #
  def serialize_to_html(file,current_item)
    logger.info("#{current_item.dom_id} #{current_item.name} converted to html ")
    
    doc = Biorails.utf8_to_codepage(current_item.to_html)
    doc = doc.gsub(/src='\/project_assets\/[0-9]*\/[0-9]*\//,"src='")
    
    if current_item.asset?
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
    return doc  
  end
  #
  # Make a html file copy all assets and html to folder_filepath
  #
  def make_htmlfile(filename)
    logger.info("Making HTML #{filename}") 
    open(File.join(filename),'w') do |file|
       file << "<h1>#{project.name}</h1>"    
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
  # create a pdf and then copy source files to as a zip and pdf to project directory
  #
  def make_pdf_for_signing
    logger.info "making pdf to sign"
    @paths=[]
    filename = File.join("/tmp","#{self.dom_id}.pdf")  
    @paths << filename 
    make_pdf(filename)
    return  make_permanent(filename)   #returns the permanent path of the document
  end
  #
  # Get the root project filepath
  #
  def project_filepath
    unless @project_filepath
      @project_filepath = File.join(RAILS_ROOT,"public",SystemSetting.get(:published_folder).value,project.dom_id)
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
  
   #$asset_root and $published_folder are configured via system settings 
    #documents are saved to a directory named following the pattern
    #$asset_root/$published_folder/project/folder/document
  def make_permanent(filename)
      begin
        @published_file_prefix =    self.dom_id+ '_V' + new_published_version.to_s  
        path=File.join(project_filepath, @published_file_prefix)
        @pdf_filename = path + '.pdf'
        @tar_filename = path + '.zip'
      end while (File.exists?(@tar_filename) or File.exists?(@pdf_filename))
      logger.info 'making permanent ' + @pdf_filename
      make_zip(@tar_filename)
      FileUtils.mv filename,  @pdf_filename       
      return @published_file_prefix
    end  
#
# Helper to return the current active project 
# 
  def self.current
    @current || Project.current.home
  end
    

protected
  
  def make_zip(destination)
     Zip::ZipFile.open(destination, Zip::ZipFile::CREATE) do |zipfile|
     # collect the album's tracks
      Dir.foreach(folder_filepath) do |path|
         if File.file?(path)
           zipfile.add(path, File.join(folder_filepath,path))
         end
      end
      return destination
     end
  end

       
end
