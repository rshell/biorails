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
# This represents a item in a folder. This could be a reference to a textual context, 
# a model or a file asset. The content and asset links are special sub types of the
# polymophic general model reference.
# 
# Each type of ProjectElement supports the following interface
# 
# description one line description of the entry
#  * icon icon for the 
#  * url
#  * name     external reference id
#  * title    external 1 line title
#  * html     html version of the content
#  * content  raw content of the elemment
#  * fill(content)
# 
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ProjectElement < ActiveRecord::Base
  attr_accessor :team_id  # historic field now removed, kept here so old fixtures can be reloaded as needed
  #
  # Legacy now removed attributes (for imports)
  #
  attr_accessor  :version_no
  attr_accessor  :previous_version
  attr_accessor  :published_version_no
  attr_accessor  :published_hash

  acts_as_fast_nested_set :order => 'project_id,left_limit',  :scope => :project_id
  
  acts_as_folder
  
  acts_as_audited :change_log
  
  acts_as_ferret :fields => [ :name, :title, :summary], :default_field=>[:name], :single_index => true, :store_class_name => true
  
  # Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>[:project_id, :parent_id, :reference_type]
  validates_presence_of   :project_id
  validates_presence_of   :name
  validates_presence_of   :position
  validates_format_of :name, :with => /^[A-Z,a-z,0-9,_,\.,\-,+,\$,\&, ,:,#]*$/, 
    :message => 'name only accept a limited range of characters [A-z,0-9,_,.,$,&,+,-, ,#,@,:]'

  attr_accessor :default_image_size
  ##
  # Base reference to ownering project.
  # project membership is used to goven access rights
  #   
  belongs_to :project
  #
  # Team owning of the element
  #
  belongs_to :team
  #
  # Access control List linked to the element
  #
  belongs_to :access_control_list
  #
  # There to another model which is is a representation of
  #
  belongs_to :reference, :polymorphic => true 
  #
  # Current content version of the element 
  #
  belongs_to :content,   :class_name =>'Content', :foreign_key => 'content_id', :dependent => :destroy
  #
  # Old reference for image assets
  #
  belongs_to :asset,     :class_name =>'Asset',  :foreign_key => 'asset_id', :dependent => :destroy
  #
  # Current status of the data element
  #
  belongs_to :state,     :class_name =>'State', :foreign_key => 'state_id'
  #
  # The Element Type defines the templates for creating,editing and show the element. This is
  # normally html,wiki,file,image etc.
  #
  belongs_to :element_type,    :class_name =>'ElementType', :foreign_key => 'element_type_id'
  #
  # List of signatures linked to this element
  #
  has_many :signatures, :order=> 'id desc',:dependent => :destroy
    
  #
  # make sure project and team are set
  # 
  before_create :initialize_element
  
  def initialize_element  
    if self.parent
      self.project ||= self.parent.project         
      self.access_control_list ||= self.parent.access_control_list
      self.team = self.parent.team
    end
    self.project ||= Project.current          
    self.team    ||= Team.current 
    self.access_control_list ||= AccessControlList.from_team(self.team)
  end 
  
  def summary
    self.title || self.name
  end
  #
  # root for views to display
  #
  def self.view_root
    nil
  end  
  #
  # Is a Image
  #
  def image?
    false
  end
  
#
# Get all items within the scope of this folder
# use like a find
# 
# folder.find_within(:all,:conditions=>{:reference_type=>'Assay'})
#
  def find_within(*args)
    ProjectElement.within_scope_of(self) do
      ProjectElement.find(*args)
    end  
  end  

  def find_outside(*args)
    ProjectElement.outside_scope_of(self) do
      ProjectElement.find(*args)
    end  
  end  

  #
  # References to Class linked to a another project
  #
  def external_references(klass)
      list = internal_references(klass).collect{|i|i.reference_id}

      ProjectElement.outside_scope_of(self) do
        ProjectElement.find(:all,:conditions => ["reference_type ='#{klass.class_name}' and reference_id in (?)",list])
    end
  end
  
  def linked_references(klass)
    ProjectElement.within_scope_of(self) do
        ProjectElement.find(:all,:conditions => ["reference_type ='#{klass.class_name}'"])
    end
  end
  #
  # References to Class linked to a this project
  #
  def internal_references(klass)
    ProjectElement.within_scope_of(self) do
      ProjectElement.find(:all,
      :conditions => "reference_type ='#{klass.class_name}' and ( select 1 from #{klass.table_name}
         where #{klass.table_name}.id=project_elements.reference_id
         and  #{klass.table_name}.project_element_id = project_elements.id) ")
    end
  end
  
  #
  # There is a signature with the element
  #
  def signed?
    self.signatures.exists?( ['signature_state=?', 'SIGNED'] )
  end
  
  def sign(options ={})
    signature = Signature.new( options.merge({
          :signature_state=>"SIGNED",
          :comments=>"",
          :created_by_user_id => User.current.id,
          :user_id=>User.current.id,
          :signature_role=> 'AUTHOR',
          :asserted_text=>SystemSetting.author_assert_text}))
    signature.project_element= self
    return signature
  end
  #
  # List of list n signatures
  #
  def signed(limit=5)
    self.signatures.find( :all , :conditions=> ['signature_state=?', 'SIGNED'],:limit=>limit )
  end

  def signature_attempts(limit=50)
    self.signatures.find( :all ,:limit=>limit )
  end


  def path(prefix = nil)
    root= self.self_and_ancestors.collect{|i|i.name}
    root[0]=prefix if prefix
    root.join('/')
  end

  # Fill the content of the project element
  # This handles hasd data passed
  #  [:name]
  #  [:title]
  #  [:content_data] 
  #  [:content_type]
  #  [:file]
  #  [:file_name]
  #  [:file_type]
  #  [:reference]
  #
  #
  def fill(item)
    case item
    when Hash
      self.name  = item[:name]
      self.title = item[:title]
      self.team  = item[:team]
      self.team_id  = item[:team_id]
      self.state = item[:state]
      self.state_id = item[:state_id]
      #
      # Add content if specified
      #
      if !item[:content_data].blank?  
        update_content(item[:content_data],item[:content_type]||'text/html') 
      end
      #
      # Add reference if specified
      #
      if !item[:reference].blank?
        update_reference(item[:reference])
      end  
      #
      # Add file if specified
      #
      if !item[:file].blank?
        file = item[:file]
        item[:file_type] ||= file.content_type     if file.respond_to?(:content_type)
        item[:file_name] ||= file.original_filename if file.respond_to?(:original_filename)
        item[:file_name] ||= File.basename(file.path) if file.is_a?(File)
        self.name  ||= item[:file_name]
        update_asset(item[:file],item[:file_name],item[:file_type])
      end
      self.title ||= self.name
     
    when ProjectElement 
      update_reference(item)
      self.content_id = item.content_id
      self.asset_id   = item.asset_id      
    when ActiveRecord::Base then     update_reference(item) 
    when ActiveRecord::Base then     update_reference(item) 
    when File then   update_asset(item,File.basename(item)) 
    when String then   update_content(item) 
    else  
      self.errors.add('content_id','no content specificied for this elemnent')
    end
    logger.warn "new element not valid: #{self.errors.full_messages().join(',')}" unless self.valid?
    self.valid?
  end

  #
  # Update the file assert for this element
  # This creates the managed files for images and attachmetns 
  #
  def update_asset(content_data,file_name, content_type =  'application/binary' )
    if content_data
      asset = Asset.new(:project_id=>self.project_id,:filename=>file_name,:content_type=>content_type)
      asset.uploaded_data = content_data  
      asset.filename ||= file_name
      asset.save!
      self.asset_id = asset.id
      self.asset = asset
    end
  end  
  #
  # Update the reference to a model in the sytem
  #
  def update_reference(item)
    if item and item.is_a?(ActiveRecord::Base)
      self.reference = item
    else
      self.errors.add(:reference,'Attempt to add invalid reference ')
    end
  end
  #
  # Update the text content for this element
  #
  def update_content(content_data, content_type = 'text/html')
    if content_data
      item = Content.new
      item.name  =     self.name
      item.title =     self.name   
      item.content_type = content_type
      item.project_id   = self.project_id
      item.body  =  content_data       
      item.body_html = process(content_data)  
      item.content_hash= Signature.generate_checksum(item.to_xml)
      item.parent = self.content    
      if self.content
         item.project_id= self.content.project_id
         content.add_child(item)
      else 
        item.save 
      end
      self.content = item   
    end     
  end  
  #
  # Add a element to the folder
  #
  def new_element(style,options={})
    name ||= Identifier.next_user_ref
    element_type = ElementType.lookup(style)
    element = element_type.new_element(self,options)
    return element
  end
  #
  # Add a element to the folder
  #
  def add_element(style,options = nil)
    ProjectElement.transaction do
      raise ActiveRecord::ActiveRecordError, "You cannot add elements to a unsaved parent" if new_record?
      element_type = ElementType.lookup(style)
      element = element_type.new_element(self)
      element.fill(options)
      self.add_child(element)
      return element
    end
  end

#
# Add a encoded files as a Base64 text string
#
  def add_asset(name, file,  content_type = nil)
    if (file.is_a?(String) and File.exists?(file)) 
      file = File.new(file) 
    end
    file_name ||= file.original_filename if file.respond_to?(:original_filename)
    file_name ||= File.basename(file.path) if file.is_a?(File)
    file_name ||= name
    add_element(ElementType::FILE,{:name=>name,:title=>name,
              :file_name=>file_name,
              :file_type=>content_type,
              :file=>file})
  end

  def add_file(name, file,  content_type = nil)
    add_element(ElementType::FILE,{:name=>name,:title=>name,:file_type=>content_type,:file=>file})
  end
##
# Add a reference to the another database model
#   
  def add_reference(name,reference=nil)    
     add_element(ElementType::REFERENCE,{:name=>name,:title=>name,:reference=>reference})
  end
  
  def add_content(name,body=nil)
     add_element(ElementType::HTML,{:name=>name,:title=>name,:content_data=>body})
  end

  def add_folder(name,reference=nil)
     add_element(ElementType::FOLDER,{:name=>name,:title=>name,:reference=>reference})    
  end
  
  def icon( options={} )
    return '/images/model/note.png'
  end  

  def image_tag
    ""
  end  
  #
  # References to a object
  #
  def self.references(instance)
     find(:all,:conditions=>{:reference_type=>instance.class_name,:reference_id=>instance.id},:order=>:id)
  end    
  #
  # Default Data processing (none)
  #
  def process(data)
    return data
  end  
  ##
  # Show the style of the project element
  # 
  def style
    if attributes['reference_type']
      attributes['reference_type'].downcase
    elsif  element_type
      element_type.name
    else
      "element"
    end
  end
  #
  # Update the Access control list for this element
  #
  def update_acl(acl,children = true)
    if (self.access_control_list_id != acl.id)
      raise "No share rights to change Access control list" unless self.access_control_list.allow?('data','share')
      raise "Not allowed remove own share rights to access control list" unless acl.allow?('data','share')
      if children
        logger.info "updating acl #{self.access_control_list_id} => #{acl.id}"
        ProjectElement.update_all(
          "access_control_list_id=#{acl.id}",
          ["access_control_list_id = ? and left_limit >=? and right_limit <=? and project_id = ?",
            self.access_control_list_id, self.left_limit, self.right_limit, self.project_id])
      else
        self.access_control_list_id = acl.id
        self.save!
      end
    end
  end  
##
# Get a root folder my name 
# 
  def folder?(item)
    return self if item == self
    return self if item.nil?
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
       logger.info "Creating folder #{item}"
       if item.is_a?(ActiveRecord::Base) and item.respond_to?(:name)
          folder = self.add_folder(item.name, item )          
       else
          folder =self.add_folder(item.to_s,nil)   
       end
    end
    return folder
  end
  
    
  #
  # Html content to display
  #
  def html
    return content.body_html if content
    return asset.image_tag if asset
    return reference.to_html if reference
    ""
  end
  #
  # Get the status of the element
  #
  def state_name
    return state.name if state
  end
  #
  # Get the owner name for the element
  #
  def owner_name
    return access_control_list_id
  end

  def to_liquid
    ProjectElementDrop.new self
  end 
  
  ##
  # check the permission to do stuff
  # 
  #  @param user a valid user to check the firsts of
  #  @param subject sybmol/string for area
  #  @param action symbol/string for the action to check
  #  @return true/false to passing check
  #
  def permission?(user,subject,action)        
    return (self.access_control_list and self.access_control_list.permission?(user,subject,action))
  end
  #
  # Check whether a action is allowed in the context of a 
  #   * Is published
  #   * If current user is a member of the team owning the record
  #   * If current user was the last author of the object.
  #
  def allow?(subject ='data', action='edit')
    return self.permission?(User.current, subject, action )
  end 
  #
  #  If the record published      
  #        
  def published?
    return (state and state.published?)
  end
  #
  #
  def can_publish?(tree=true)
    return false unless valid? and state.completed? and !state.published?
    if tree    
      for item in all_children
        return false unless item.can_publish?(false)
      end
    end 
    true
  end
  #
  # Check whether object should be visible in this context
  #   * Is published
  #   * If current user is a member of the team owning the record
  #   * If current user was the last author of the object.
  #
  def visible?(user =nil)    
    user ||= User.current
    return true if self.published? or user.admin? or self.access_control_list.has_access?(user)
    return (self.created_by_user_id == user.id) || (self.updated_by_user_id == user.id)
  end

  #
  # custom conversion to xml
  #
  def to_xml(options = {})
       my_options = options.dup
       my_options[:include] = [:content,:asset]
      Alces::XmlSerializer.new(self, my_options ).to_s
  end


  def contained_references_to(klass)
    klass.find_by_sql("select * from #{klass.table_name} where #{ exists_within_sql_filter(klass)}")
  end
  
  def exists_within_sql_filter(klass)
   sql =  <<-TEXT
    exists ( select 1 from project_elements 
        where project_elements.left_limit>= #{self.left_limit} 
        and project_elements.right_limit <= #{self.right_limit}
        and project_elements.project_id  =  #{self.project_id}
        and project_elements.reference_type='#{klass.class_name}'
        and #{klass.table_name}.id = project_elements.reference_id )  
TEXT
  sql
  end  
  #
  # Get all the elements with reference to the passed item
  #
  def self.references(item)
    case item
    when Class
      self.find(:all,:conditions=>['reference_type=? ',item.class_name])
    when Symbol,String
      self.find(:all,:conditions=>['name=? and reference_type is not null ',item.to_s])
    when ActiveRecord::Base
      self.find(:all,:conditions=>['reference_type=? and reference_id=?',item.class.class_name,item.id])
    else
      []
    end
  end

end
