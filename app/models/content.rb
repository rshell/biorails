# == Schema Information
# Schema version: 359
#
# Table name: project_contents
#
#  id                 :integer(4)      not null, primary key
#  project_id         :integer(4)      not null
#  type               :string(20)
#  name               :string(255)
#  title              :string(255)
#  body               :text
#  body_html          :text
#  author_ip          :string(100)
#  published          :boolean(1)
#  content_hash       :string(255)
#  lock_timeout       :datetime
#  lock_user_id       :integer(4)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  left_limit         :integer(4)
#  right_limit        :integer(4)
#  parent_id          :integer(4)
#  content_type       :string(255)
#  content_size       :integer(4)
#  db_file_id         :integer(4)
#

# == Description
#The content management system is implemented as folders that hold the content such as articles, 
#images and files. This system of folders is built against the research structure provided by BioRails. 
#For example, every assay, experiment task and request has a folder.
#
# This model contains a version of the content for a element in a folder
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Content < ActiveRecord::Base 
  include ActionView::Helpers::NumberHelper
  set_table_name 'project_contents'
  #
  # Legacy now removed attributes (for imports)
  #
  attr_accessor  :comments_count
  attr_accessor  :comment_age
  
  #
  # Denormalized project_id to help is partition of the database
  #
  belongs_to :project, :class_name=>'Project', :foreign_key => 'project_id'
  belongs_to :created_by_user, :class_name=>'User', :foreign_key => 'created_by_user_id'
  belongs_to :updated_by_user, :class_name=>'User', :foreign_key => 'updated_by_user_id'

  acts_as_fast_nested_set :parent_column => 'parent_id', :scope => :project_id
     
  validates_presence_of   :project_id
  validates_presence_of   :title
  validates_presence_of   :name
  #
  # List of all the project elements with a link to this as there current content
  # 
  has_many :elements,  :class_name  =>'ProjectElement',  :foreign_key =>'content_id',  :dependent => :destroy
  #
  # The textual information is linked into a number of folders
  #   
  has_many :folders,:through    => :elements,    :source     => :content

  
  def html_urls
    urls = Array.new
    (body_html.to_s).gsub(/<a [^>]*>/) do |tag|
      if(tag =~ /href="([^"]+)"/)
        urls.push($1)
      end
    end
    urls
  end
  
  def summary
    out = ' ' 
    out << title
    out << ' ['
    out << number_to_human_size( self.body_html.size) if self.body_html
    out << "]"  
  end  

end
