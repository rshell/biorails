# == Schema Information
# Schema version: 233
#
# Table name: sections
#
#  id                  :integer(11)   not null, primary key
#  name                :string(255)   
#  show_paged_articles :boolean(1)    
#  articles_per_page   :integer(11)   default(15)
#  layout              :string(255)   
#  template            :string(255)   
#  project_id          :integer(11)   
#  path                :string(255)   
#  articles_count      :integer(11)   default(0)
#  archive_path        :string(255)   
#  archive_template    :string(255)   
#  position            :integer(11)   default(1)
#  parent_id           :integer(11)   
#  desciption          :text          
#  lock_version        :integer(11)   default(0), not null
#  created_by          :string(32)    default(), not null
#  created_at          :datetime      not null
#  updated_by          :string(32)    default(), not null
#  updated_at          :datetime      not null
#

class Section < ActiveRecord::Base
  ARTICLES_COUNT_SQL = 'INNER JOIN assigned_sections ON contents.id = assigned_sections.article_id INNER JOIN sections ON sections.id = assigned_sections.section_id'.freeze unless defined?(ARTICLES_COUNT)

  before_validation :set_archive_path
  before_validation_on_create :create_path
  validates_presence_of   :name, :project_id, :archive_path
  validates_format_of     :archive_path, :with => Format::STRING
  validates_exclusion_of  :path, :in => [nil]
  validates_uniqueness_of :path, :case_sensitive => false, :scope => :project_id

  belongs_to :project

  has_many :assigned_sections, :dependent => :delete_all

  has_many :articles, :order => 'position', :through => :assigned_sections do
    def find_by_position(options = {})
      find(:first, { :conditions => ['contents.published_at <= ? AND contents.published_at IS NOT NULL', Time.now.utc] } \
        .merge(options))
    end

    def find_by_permalink(permalink, options = {})
      find(:first, { :conditions => ['contents.permalink = ? AND published_at <= ? AND contents.published_at IS NOT NULL',
                                      permalink, Time.now.utc] }.merge(options))
    end
  end

  class << self
    # scopes a find operation to return only paged sections
    def find_paged(options = {})
      with_scope :find => { :conditions => ['show_paged_articles = ?', true] } do
        block_given? ? yield : find(:all, options)
      end
    end

    def articles_count
      Article.count :all, :group => :section_id, :joins => ARTICLES_COUNT_SQL
    end
    
    def permalink_for(str)
      str.gsub(/[^\w\/]|[!\(\)\.]+/, ' ').strip.downcase.gsub(/\ +/, '-')
    end
  end

  def find_comments(options = {})
    Comment.find_all_by_section(self, options)
  end

  def to_liquid(current = false)
    SectionDrop.new self, current
  end

  # orders articles assigned to this section
  def order!(*sorted_ids)
    transaction do
      sorted_ids.flatten.each_with_index do |article, pos|
        assigned_sections.detect { |s| s.article_id.to_s == article.to_s }.update_attributes(:position => pos)
      end
      save
    end
  end

  def hash_for_url(options = {})
    { :path => to_url }.merge(options)
  end

  def home?
    path.blank?
  end

  def to_url
    path.split('/')
  end

  def paged?
    show_paged_articles?
  end
  
  def blog?
    !show_paged_articles?
  end

  def to_page_url(page_name)
    to_url << (page_name.respond_to?(:permalink) ? page_name.permalink : page_name)
  end

  def to_feed_url
    to_page_url 'atom.xml'
  end
  
  def to_comments_url
    to_page_url 'comments.xml'
  end
  
  protected
    def set_archive_path
      self.archive_path = 'archives' if archive_path.blank?
      archive_path.downcase!
    end

    def create_path
      self.path = 
        case path
          when nil then ''
          when ''  then self.class.permalink_for(name.to_s)
          else          path
        end
    end
end
