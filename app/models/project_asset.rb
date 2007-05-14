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

class ProjectAsset < ActiveRecord::Base
   include ActionView::Helpers::NumberHelper
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
 
  attr_accessor :tag_list

  #validates_uniqueness_of :filename, :scope => 'project_id'
  validates_presence_of   :filename

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
# This could be a image file, csv raw data, office document or many other thinks.
# 
  has_attachment :max_size => 5000.kilobytes,
                 :resize_to => '3000x2000>',
                 :storage => :db_file,
                 :thumbnails => {:normal=>'320x200', :icon => '48x48' }

  validates_as_attachment

##
# All assets belong to a project with owns them and governs there access rights. In the system
# a attempt to partition data by project has been used.
#                    
  belongs_to :project  

##
# A assert may be referenced as a element in a number of folders to allow its inclusion into 
# reports and analysis.
#   
  has_many :references,  :class_name  =>'ProjectElement',  :foreign_key =>'reference_id',:dependent => :destroy
  has_many :elements,  :class_name  =>'ProjectElement',  :foreign_key =>'asset_id',:dependent => :destroy

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
  
  def image_tag(max = 700)
   return "<img src='/images/model/file.png' />"  unless image?
   if max and self.width and (max.to_i <= self.width.to_i )
      "<img src=#{self.public_filename}  width='100%'/>"  
   else
      "<img src=#{self.public_filename} />" 
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

  def summary
     out = number_to_human_size( size)
     out << " "  << content_type 
     if width 
       out << " (W x H) "
       out << " "<< width.to_s
       out << " x "
       out << " " << height.to_s
     end          
  end
  
  
end
