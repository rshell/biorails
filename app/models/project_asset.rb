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
require 'digest/md5'
require 'digest/sha1'

class ProjectAsset < ProjectElement

  validates_associated :asset
  
  def ProjectAsset.build(options ={} )
    puts "build project_asset #{options.to_s}" 
    options = options.symbolize_keys()
    element = ProjectAsset.new
    element.name = options[:name] || options[:filename] 
    element.parent = options[:parent]
    element.project_id = options[:project_id]
    element.position =  options[:position]
    element.name =  options[:name]
    element.path = options[:path]
    
    element.asset = Asset.new
    element.asset.title =        options[:title]       
    element.asset.project_id =   options[:project_id]    
    element.asset.content_type = 'application/binary'
    if   options[:uploaded_data] 
      element.asset.uploaded_data  =  options[:uploaded_data]  
      element.name = element.asset.filename
    end
    element.asset.content_type = options[:content_type] 
    puts element.asset.title
    
    puts "project_asset #{element.to_yaml}" 
    return element
  end

  def before_save
    self.asset.save if self.asset
  end
  
  def url
   self.asset.public_filename  if self.asset
  end
  
  def title
   asset.title 
  end
  
  def title=(value)
    asset.title=value
  end

  def content_type
   asset.content_type 
  end

  def content_type=(value)
   asset.content_type =value
  end

  def to_html
    return "<img alt="#{title}" src=''#{self.url}'' />"
  end
  
  def signature
   asset.signature 
  end


  def filename
    name  
  end

  def filename=
    name = filename
    filename = filename
  end

  def caption
    asset.caption
  end
  
  def caption=(value)
    asset.caption=value
  end
  
  def uploaded_data=(value)
    asset.uploaded_data
    name ||= asset.filename
  end

  def image?
    asset.image?
  end

##
# File assets  

  def description
    return asset.title if asset
    return path
  end


  def icon( options={} )
     return asset.icon(options) if asset?
     '/images/model/file.png'
  end  
  
  def summary
     return asset.summary if asset
     return path
  end  
end
