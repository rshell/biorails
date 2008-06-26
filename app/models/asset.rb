# == Schema Information
# Schema version: 306
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
#  size_bytes         :integer(11)   
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
#  caption            :string(2048)  
#  db_file_id         :integer(11)   
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

class Asset < ActiveRecord::Base
   include ActionView::Helpers::NumberHelper

  set_table_name 'project_assets'

##
# All assets belong to a project with owns them and governs there access rights. In the system
# a attempt to partition data by project has been used.
#                    
  belongs_to :project  

##
# A asset may be referenced as an element in a number of folders to allow its inclusion into 
# reports and analysis.
#   
  has_many :references,  :class_name  =>'ProjectElement',  :foreign_key =>'reference_id',:dependent => :destroy
  has_many :elements,  :class_name  =>'ProjectElement',  :foreign_key =>'asset_id',:dependent => :destroy

##
# To allow for existing of previews, images and multiple derived versions of a asset child records are
#  created. The two main use cases are thumbnail preview images and windows clipboard multiple formats ( for client application use)
#   
  acts_as_tree :order => "name"   

##
# binary data stored separately in id/data table to help with queries etc.   
  belongs_to :db_file    
##
# The main purpose of a Project asset is is to act as a link to external raw/process data block.
# This could be a image file, csv raw data, office document or many other things.
# 
  has_attachment :max_size => 5000.kilobytes,
                 :resize_to => '3000x2000>',
                 :storage => :db_file,
                 :path_prefix =>  File.join('project_assets'),
                 :thumbnails => {:normal=>'640x400', :icon => '48x48' }

  #validates_uniqueness_of :filename, :scope => 'project_id'
  validates_presence_of   :filename
  validates_as_attachment
  
  def before_validation 
    logger.info "set self.content_type for #{filename} to #{self.content_type}"
    self.content_type =  MIME::Types.type_for(filename).to_s if filename
    self.content_type = 'application/binary'  if self.content_type.empty?   
    logger.info "set self.content_type to #{self.content_type}"
  end
  
##
# calculate the signature of a record and return the result.
# This is a MD5 checksum of the current fields in the record
# 
  def signature(fields =  nil )
     fields ||= attributes.keys
     keys = attributes.keys - ['content_hash']
     data = keys.collect{|key| "#{key}:#{attributes[key]}"}.join(',')
     data << 'file:' << Digest::MD5.hexdigest(File.read(self.full_filename))
     Digest::MD5.hexdigest(data )
  end
  
  def image_tag(default_image_size=:normal,max = 700)
   return "<img src='/images/model/file.png' />"  unless image?
   if max and self.width and (max.to_i <= self.width.to_i )
     "<img width='99%' class='asset' src='#{self.public_filename(default_image_size)}'  alt='#{self.filename}'/>" 
   else
      "<img class='asset' src='#{self.public_filename(default_image_size)}' alt='#{self.filename}'/>" 
   end
  end
  
  def icon( options={} )
     if image? and options[:images]
        self.public_filename(:icon)
     else
        '/images/model/file.png'
     end  
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")
      '/images/model/file.png'
  end

  def size
    self.size_bytes
  rescue Exception => ex
      logger.error ex.message
    return 0           
  end

  def size=(value)
    self.size_bytes=value
  end

  def mime_type
    MIME::Types[self.content_type]  
  end
  
  def description
    return self.caption
  end 

  def description=(value)
    self.caption = value
  end 
  
  def summary
     out = number_to_human_size( size)
     out << " "  << content_type 
     if width 
       out << " (W x H) "
       out << " "<< width.to_s
       out << " x "
       out << " " << height.to_s
     end      
     out.to_s     
  end
  
  

end
