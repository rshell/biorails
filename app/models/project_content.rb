# == Schema Information
# Schema version: 239
#
# Table name: project_contents
#
#  id                 :integer(11)   not null, primary key
#  project_id         :integer(11)   not null
#  type               :string(20)    
#  name               :string(255)   
#  title              :string(255)   
#  body               :text          
#  body_html          :text          
#  author_ip          :string(100)   
#  comments_count     :integer(11)   default(0)
#  comment_age        :integer(11)   default(0)
#  published          :boolean(1)    
#  content_hash       :string(255)   
#  lock_timeout       :datetime      
#  lock_user_id       :integer(11)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# This represents a piece of textual content associated with a project
class ProjectContent < ActiveRecord::Base

  attr_accessor :tags

##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
  
  belongs_to :project

  has_many :elements,  :class_name  =>'ProjectElement',
                       :foreign_key =>'reference_id'
##
# The textual information is linked into a number of folders
#   
  has_many :folders,:through    => :elements, 
                    :source     => :content,
                    :conditions => "elements.reference_type = 'ProjectContent'"

  def html_urls
    urls = Array.new
    (body_html.to_s + extended_html.to_s).gsub(/<a [^>]*>/) do |tag|
      if(tag =~ /href="([^"]+)"/)
        urls.push($1)
      end
    end
    urls
  end


  def to_html
      
  end
  
  
##
# calculate the signature of a record and return the result.
# This is a MD5 checksum of the current fields in the record
# 
  def signature(fields =  nil )
     fields ||= attributes.keys
     keys = attributes.keys - ['content_hash']
     data = keys.collect{|key| "#{key}:#{attributes[key]}"}.join(',')
     Digest::MD5.hexdigest(data )
  end
  
         
end
