# == Description
# ProjectAsset is the gatekeeping between internally kept data and external files. 
# Th ProjectAsset allows the attachment of image.
#
# === Structure
#    * An ProjectAsset belongs to a project
#    * ProjectAsset may be referred to in many sections
#    * ProjectAsset has a mime-type which reflects their format
#    * ProjectAssets have a current up-loader
#    * ProjectAssets can be: published (visible to subscribers) or internal (only visible to team members)
#    * ProjectAssets may be associated with other BioRails entries such as Studies, Projects, Experiments, 
#     Tasks, Results etc) 
#
#In current model the version history of asset is not managed as part of the application. 
#A separate document management system is expected to do this. The default option for 
#this will be to use a subversion repository for this. If you going down the long term 
#document-management route need to use system which will be around for past 5 and next 15
# years and subversion fits the bill!  
# 
# In initial version the application
# server file system is used for storage but it is expected that the following may be added as neededd:-
# 
#  * Subversion 
#  * In Database blobs
#  * Web Service to document/file management systems
#  * Link to 3rd part applications like ELN's

#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
# == Schema Information
# Schema version: 338
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

class ProjectAsset < ProjectElement
   
  validates_presence_of   :asset_id 
   validates_associated :asset

  def content_type
   asset.content_type if asset
  end

  def content_type=(value)
   asset ||= Asset.new 
   asset.content_type =value
  end

  def signature
   asset.signature if asset
  end

  def filename
    asset.filename if asset
  end

  #
  # Set the Data from a form
  #
  def file=(value)
    fill(value)
  end
  #
  # Set the Content Data for use in forms
  #
  def file
    self.asset.public_filename  if self.asset    
  end

  def content_data
    self.asset.public_filename  if self.asset    
  end

  def self.view_root
    File.dirname(__FILE__)+'/../views/project_asset'
  end

  def url
    self.asset.public_filename  if self.asset
  end

  def image?
    asset.image? if asset
  end
#
# html version of the image basically a image tag
#
  def html
    if self.asset
      self.asset.image_tag(default_image_size,600)
    else
      "[no image]"    
    end
  end
##
# File assets  

  def icon( options={} )
     return asset.icon(options) if image?
     '/images/model/file.png'
  end  
  
end
