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

# == Schema Information
# Schema version: 233
#
# Table name: project_assets
#
#  id               :integer(11)   not null, primary key
#  project_id       :integer(11)   
#  parent_id        :integer(11)   
#  title            :string(255)   
#  content_type     :string(255)   
#  filename         :string(255)   
#  size             :integer(11)   
#  thumbnail        :string(255)   
#  width            :integer(11)   
#  height           :integer(11)   
#  thumbnails_count :integer(11)   default(0)
#  lock_version     :integer(11)   default(0), not null
#  created_by       :string(32)    default(sys), not null
#  created_at       :datetime      not null
#  updated_by       :string(32)    default(sys), not null
#  updated_at       :datetime      not null
#
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

  attr_accessor :tags

  validates_uniqueness_of :filename, :scope => 'project_id'
  validates_presence_of   :filename

##
# To allow for existing of previews, images and multiple derived versions of a asset child records are
#  created. The two main use cases are thumbnail preview images and windows clipboard multiple formats ( for client application use)
#   
  acts_as_tree :order => "name"    
##
# The main purpose of a Project asset is is to act as a link to external raw/process data block.
# This could be a image file, csv raw data, office document or many other thinks.
# 
  has_attachment :storage => :file_system, 
                 :max_size => 5000.kilobytes,
                 :resize_to => '3000x2000>',
                 :thumbnails => { :large=>'800x600', :normal=>'320x200', :small => '100x100>', :icon => '48x48' }

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
#  has_many :elements,  :class_name  =>'ProjectElement',  :foreign_key =>'reference_id'


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
  
end
