# == Description
# This represents a piece of textual content associated with a project
# ProjectContent provide support for unstructured textual information. 
# This may be a short paragraph or a long document. Generally other larger outputs like 
# study reports, components documents are built out of ProjectAsset.
#
# ProjectContent will usually be entered as text, html or one of common wiki mark-up languages. 
# As scientists have more interesting things to do then learn wiki syntax, the main form of entry will 
# be a rich text editor with cut and paste to MS-Office.
#
# === Structure
#    * ProjectContent belong to a project
#    * ProjectContent may be referred to in many sections
#    * ProjectContent have a version history to record changes
#    * ProjectContent have a mark-up governing the format of the text (HTML,Text, etc)
#    * ProjectContent have a current author
#    * ProjectContent may are published (visible to subscribers), internal (only visible to team members)
#    * ProjectContent may be associated with other BioRails entries (Studies,Projects,Experiments,Tasks, Results etc)
#    * ProjectContent may have associated asset (images,raw data files etc) 
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

class ProjectContent < ProjectElement

   validates_presence_of :content_id 
   validates_associated :content

  def icon( options={} )
     '/images/model/note.png'
  end  
  
  def self.view_root
    File.dirname(__FILE__)+'/../views/project_content'
  end
  #
  # Process the body to generate a html version
  #
  def process(data)
    data.gsub(/<[\!DOC,\?xml](.*?)>[\n]?/m, "") 
  end
  
  def style
    'html'
  end

  def content_type
   content.content_type if content
  end

  def url
    ""
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
  
  def html
    content.body_html if content
  end



end
