# == Schema Information
# Schema version: 239
#
# Table name: project_assets
#
#  id                 :integer(11)   not null, primary key
#  project_id         :integer(11)   
#  title              :string(255)   
#  parent_id          :integer(11)   
#  content_type       :string(255)   
#  filename           :string(255)   
#  thumbnail          :string(255)   
#  size               :integer(11)   
#  width              :integer(11)   
#  height             :integer(11)   
#  thumbnails_count   :integer(11)   default(0)
#  published          :boolean(1)    
#  content_hash       :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# ProjectAsset is the gatekeeping between internally kept data and external files. In initial version the application
# server file system is used for storage but it is expected that the following may be added as neededd:-
# 
#  * Subversion 
#  * In Database blobs
#  * Web Service to document/file management systems
#  * Link to 3rd part applications like ELN's
# 
# 
# 

class ProjectAsset < ProjectElement

  validates_associated  :asset
  validates_presence_of :asset_id
  

  def ProjectAsset.build( options ={} )
    options = options.symbolize_keys()
    my_element = ProjectAsset.new
    my_element.name   = options[:name] 
    my_element.name ||= options[:filename] 
    my_element.project_id = options[:project_id]
    my_element.position =  options[:position]
    my_element.name =  options[:name]
    
    asset = Asset.new
    asset.title =        options[:title]       
    asset.project_id =   options[:project_id]    
    asset.content_type = 'application/binary'
    asset.caption = options[:description]
    if   options[:uploaded_data] 
      asset.uploaded_data  =  options[:uploaded_data]  
      my_element.name = asset.filename
    end
    asset.content_type = options[:content_type] 
    asset.save
    my_element.asset_id = asset.id
    my_element.asset = asset
    return my_element
  end
  

  def before_save
    self.asset.save if self.asset
  end
  
  def url
   self.asset.public_filename  if self.asset
  end
  
  def title   
   asset.title if asset
  end
  
  def title=(value)
    asset ||= Asset.new 
    asset.title=value
  end

  def content_type
   asset.content_type if asset
  end

  def content_type=(value)
   asset ||= Asset.new 
   asset.content_type =value
  end

  def to_html
    return "<img alt="#{title}" src=''#{self.url}'' />"
  end
  
  def signature
   asset.signature if asset
  end

  def filename
    name  
  end

  def summary
     return asset.summary if asset
     return path
  end

  def description
    return asset.caption if asset
    return name
  end

  
  def description=(value)
    asset ||= Asset.new 
    asset.caption=value
  end
  
  def uploaded_data=(value)
    asset ||= Asset.new 
    asset.uploaded_data=value
    name ||= asset.filename
  end

  def image?
    asset.image? if asset
  end

##
# File assets  

  

  def icon( options={} )
     return asset.icon(options) if asset?
     '/images/model/file.png'
  end  
  
end
