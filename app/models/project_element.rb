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
  
  # Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>[:project_id, :parent_id, :reference_type]
  validates_presence_of   :project
  validates_presence_of   :state
  validates_presence_of   :element_type
  validates_presence_of   :access_control_list
  validates_presence_of   :name
  validates_presence_of   :position
  validates_format_of :name, :with => /^[A-Z,a-z,0-9,_,\.,\-,+,\$,\&, ,:,#,\/]*$/,
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

  has_many :elements,  :class_name  => 'ProjectElement',
    :foreign_key => 'parent_id',
    :include => [:asset,:content,:state],
    :order       => 'project_elements.left_limit' 
  #
  # There to another model which is is a representation of
  #
  belongs_to :reference, :polymorphic => true 
  #
  # Current content version of the element 
  #
  belongs_to :content,   :class_name =>'Content', :foreign_key => 'content_id'
  #
  # Old reference for image assets
  #
  belongs_to :asset,     :class_name =>'Asset',  :foreign_key => 'asset_id'
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
  # make sure project and team are set
  # 
  before_validation_on_create :initialize_element
  
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
        :conditions => "reference_type ='#{klass.class_name}'
 and exists ( select 1 from #{klass.table_name}
         where #{klass.table_name}.id=project_elements.reference_id
         and  #{klass.table_name}.project_element_id = project_elements.id) ")
    end
  end
  

  def path(prefix = nil)
    root= self.self_and_ancestors.collect{|i|i.name}
    root[0]=prefix if prefix
    root.join('/')
  end
  #
  # Find all elements matching a path
  #
  def self.list_all_by_path(text)
    path_element_list = text.split('/')
    return ProjectElement.list(:all,:conditions=>['project_elements.parent_id is null and project_elements.name like ?',text]) if path_element_list.size < 2

    text = path_element_list.pop
    parent_item = ProjectElement.find(:first,:conditions=>['project_elements.parent_id is null and project_elements.name = ?',path_element_list.delete_at(0)])
    return [] unless parent_item
    path_element_list.each do |path_item|
       parent_item = parent_item.elements.find(:first,:conditions=>['project_elements.name = ?',path_item])
       return [] unless parent_item
    end
    ProjectElement.list(:all,:conditions=>['project_elements.parent_id= ? and project_elements.name like ?', parent_item.id,text])
  end

  def self.find_by_path(text)
    path_element_list = text.split('/')
    parent_item = find(:first,:conditions=>['project_elements.parent_id is null and project_elements.name = ?',path_element_list.delete_at(0)])
    path_element_list.each do |path_item|
       return nil unless parent_item
       parent_item = parent_item.elements.find(:first,:conditions=>['project_elements.name = ?',path_item])
    end
    parent_item
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
      self.state_id = item[:state_id] unless item[:state_id].blank?
      self.state ||= State.find(:first)
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
      item.parent = self.content    
      if self.content
        item.project_id= self.content.project_id
        self.content.add_child(item)
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
      raise ActiveRecord::ActiveRecordError, "Failed to added child as parent not saved: "+self.errors.full_messages().join("\n") if (self.new_record? and !self.save)
      raise ActiveRecord::ActiveRecordError, "This folder is not changeable"  unless self.changeable?
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
    raise "No share rights to change Access control list" unless self.access_control_list.right?('data','share')
    raise "Not allowed remove own share rights to access control list" unless acl.right?('data','share')
    ProjectElement.transaction do
      if (self.access_control_list_id != acl.id)
        if children
          logger.info "updating acl #{self.access_control_list_id} => #{acl.id}"
          ProjectElement.update_all( "access_control_list_id=#{acl.id}",
            ["access_control_list_id = ? and left_limit >=? and right_limit <=? and project_id = ?",
              self.access_control_list_id, self.left_limit, self.right_limit, self.project_id])
        else
          self.access_control_list_id = acl.id
          self.save!
        end
      end
    end
  end  
  ##
  # Get a root folder my name
  #
  def folder?(item = nil)
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
  def folder(item=nil)
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
  
  # Set the Data from a form
  #
  def content_data=(value)
    fill(value)
  end
  #
  # Set the Content Data for use in forms
  #
  def content_data
    content.body_html if content
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

  def to_html(cache=true)
    html
  end
  #
  # Get the status of the element
  #
  def state_name
    return state.name if state
    "new"
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
  def right?(subject ='data', action='edit')
    return self.permission?(User.current, subject, action )
  end 
  #
  #  If the record published      
  #        
  def published?
    return (!state.nil? and state.published?)
  end

  def deletable?
    self.all_children_count==0 && 
      self.changeable? &&
      self.right?(:data,:destroy) &&
      (self.reference.blank? or self.reference.is_a?(ProjectElement))   
  end

  def state_flow
    self.project.state_flow || StateFlow.find(:first)
  end
  #
  #
  def allow_state?(new_state,cascade=false)
    return false unless self.valid? and self.state and state_flow.allow?(state,new_state) and self.state != new_state
    if cascade
      for item in self.all_children
        return false unless item.allow_state?(new_state,tree=false)
      end
    end
    true
  end
  #
  # List allowed_states from the current one, with a optional check of children
  #
  def allowed_states(cascade=false)
    return [State.find(:first)] if self.new_record? || self.state.nil?

    allowed = self.state_flow.next_states( self.state)
    if cascade 
      self.all_children.each do |item|
        unless  item.state and (item.state.ignore? or item.state.published?)
          allowed = allowed & item.allowed_states(false)

        end
      end
    end
    allowed ||= [self.state]
  end

  #
  # See if record is fixed in the current context
  #
  def changeable?
    (self.new_record? or  self.nil? or self.state.nil? or
        self.state_flow.nil? or
        (right?(:data,:update) and self.state.editable?))
  end
  #
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

  ##
  # Textual content stripped of all html tags odd characters etc
  #
  def to_text
    return "" unless content
    text = ""
    tokenizer = HTML::Tokenizer.new(html)
    while token = tokenizer.next
      node = HTML::Node.parse(nil, 0, 0, token, false)
      text << node.to_s if node.class == HTML::Text
    end
    text =  text.gsub(/<!--(.*?)-->[\n]?/m, "").gsub(/<[\!DOC,\?xml](.*?)>[\n]?/m, "").gsub(/[\n,\t, ]+/," ")
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    return ic.iconv(text)
  end
  #
  # custom conversion to xml
  #
  def to_xml(options = {})
    my_options = options.dup
    my_options[:include] = [:content,:asset]
    Alces::XmlSerializer.new(self, my_options ).to_s
  end

  #
  # Get all the elements with reference to the passed item
  #
  def self.references(item)
    case item
    when Class
      self.list(:all,:conditions=>['reference_type=? ',item.to_s])
    when Symbol,String
      self.list(:all,:conditions=>['name=? and reference_type is not null ',item.to_s])
    when ActiveRecord::Base
      self.list(:all,:conditions=>['reference_type=? and reference_id=?',item.class.to_s, item.id])
    else
      []
    end
  end

  # set the state and manage started_at and ended_at and record status_id
  #
  # 1) get new/old state and check there is a state flow
  # 2) in set check all children
  # 3) otherwize only change state when live and level same or greater
  # 4) update own state only after all children done
  #
  def set_state(new_state,recusive = true)
    logger.info  "State change #{self.state} => #{new_state}"

    ProjectElement.transaction do
      new_state = State.get(new_state)

      unless (self.state_flow)
        self.errors.add(:state,"there is no state_flow defined to element")
        return nil
      end

      unless (self.state)
        self.errors.add(:state,"there is no state defined to element")
        return nil
      end
      
      if new_state.check_children? 
        self.all_children.each do |item|
          if (item.state.level_no > State::ERROR_LEVEL or item.state == self.state)
            item.update_state_and_reference(new_state)
          end
        end
  
      elsif recusive
        self.all_children.each do |item|
          if ( self.state_flow.allowed_state_change?(item,new_state)  and
                (item.state.level_no > State::ERROR_LEVEL or item.state == self.state) and
                (item.state.level_no <= new_state.level_no ))
            item.update_state_and_reference(new_state)
          end
        end

      end

      update_state_and_reference(new_state)
      self.state
    end

  end




  protected

  #
  # 1) Check is a valid change of state
  # 2) Check user has rights to change state
  # 3) If reference is valid
  # 4) update status_id to level it present
  # 5) update ended_at if now finished
  # 6) update state
  #
  def update_state_and_reference(new_state)

    unless  self.state_flow.allowed_state_change?(self,new_state)
      raise "Invalid request cant change state #{self.state} => #{new_state}"
    end

    unless  self.right?(:data,:verify)
      raise "No rights to change state #{self.path} "
    end

    if (reference)
      unless reference.valid? or new_state.ignore?
        raise "Cant update state of #{self.path} as reference object is not valid"
      end

      reference.status_id = new_state.level_no if reference.respond_to?(:status_id)

      if (!self.state.finished? and reference.respond_to?(:ended_at) and new_state.finished? )
        reference.ended_at = Time.now if reference.ended_at.blank?
        reference.save!

      elsif (self.state.level_no != new_state.level_no)
        reference.save!

      end
    end

    self.state = new_state
    self.save!
  end

end
