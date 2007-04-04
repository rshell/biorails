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

class ProjectAsset < ActiveRecord::Base

  validates_uniqueness_of :name, :scope =>"parent_id"
  validates_presence_of   :name
  validates_presence_of   :description


  acts_as_tree :order => "name"    
  
  has_attachment :content_type => ['application/pdf', 'application/msword', 'text/plain','image'], 
                 :max_size => 5000.kilobytes,
                 :storage => :file_system, 
                 :path_prefix => 'public/files',
                 :thumbnails => { :thumb => '100x100>' }
                   
  belongs_to :project  
  
  has_many :elements,  :class_name  =>'ProjectElement',
                       :foreign_key =>'reference_id'
##
# The textual information is linked into a number of folders
#   
  has_many :folders,:through    => :elements, 
                    :source     => :asset,
                    :conditions => "elements.reference_type = 'ProjectAsset'"
                    

end
