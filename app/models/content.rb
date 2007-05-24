class Content < ActiveRecord::Base 
  include ActionView::Helpers::NumberHelper

  set_table_name 'project_contents'


##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
  
  belongs_to :project

  validates_presence_of   :project_id
  validates_presence_of   :title
  validates_presence_of   :name


  has_many :references,  :class_name  =>'ProjectElement',  :foreign_key =>'reference_id',:dependent => :destroy
  has_many :elements,  :class_name  =>'ProjectElement',  :foreign_key =>'content_id',  :dependent => :destroy

##
# The textual information is linked into a number of folders
#   
  has_many :folders,:through    => :elements,               :source     => :content

  def html_urls
    urls = Array.new
    (body_html.to_s + extended_html.to_s).gsub(/<a [^>]*>/) do |tag|
      if(tag =~ /href="([^"]+)"/)
        urls.push($1)
      end
    end
    urls
  end


  def icon(options={} )
        '/images/mime/html.png'
  end
  
  def summary
     out = ' ' 
     out << title
     out << ' ['
     out << number_to_human_size( body_html.size)
     out << "]"  
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
