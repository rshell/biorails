# == Schema Information
# Schema version: 233
#
# Table name: project_contents
#
#  id             :integer(11)   not null, primary key
#  project_id     :integer(11)   
#  name           :string(255)   
#  title          :string(255)   
#  excerpt        :text          
#  body           :text          
#  excerpt_html   :text          
#  body_html      :text          
#  type           :string(20)    
#  author_ip      :string(100)   
#  comments_count :integer(11)   default(0)
#  comment_age    :integer(11)   default(0)
#  approved       :boolean(1)    
#  lock_version   :integer(11)   default(0), not null
#  created_by     :string(32)    default(sys), not null
#  created_at     :datetime      not null
#  updated_by     :string(32)    default(sys), not null
#  updated_at     :datetime      not null
#  published_by   :string(255)   
#  published_at   :datetime      
#

##
# This represents a piece of textual content associated with a project
class ProjectContent < ActiveRecord::Base
  attr_accessor :tags

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
