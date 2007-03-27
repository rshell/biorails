##
# This is the only web root path and investigation log for project.
# The Projects is build of organizational elements (Studies/Protocols/Services)
# execution elements covering the capture of data (experiments/tasks)
# and documentation build of a number of sections containing articles,assets,comments,reports etc.
# 
# Then the whole system is split into a internal view managed my members of the project and a public view 
# seen by subscribers.
#  
require 'tzinfo'

class Project < ActiveRecord::Base
  cattr_accessor :multi_projects_enabled
  cattr_accessor :cache_sweeper_tracing

  ##
  # Link to Document Management repository (subversion,documentum etc)
  belongs_to :repository, :class_name => 'Repository', :foreign_key=>'repository_id'

  has_many :studies,     :through => :project_studies,      :source => :study
  has_many :experiments, :through => :project_experiments,  :source => :experiment

  has_many  :comments, :order => 'comments.created_at desc'
  has_many  :events
  has_many  :cached_pages
  has_many  :assets, :order => 'created_at desc', :conditions => 'parent_id is null'
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_many :owners,  :through => :memberships, :source => :user, :conditions => ['memberships.owner = ? or users.admin = ?', true, true]


  has_many  :sections, :order => "position" do
    def home
      find_by_path ''
    end

    # orders sections in a project
    def order!(*sorted_ids)
      transaction do
        sorted_ids.flatten.each_with_index do |section_id, pos|
          Section.update_all ['position = ?', pos], ['id = ? and project_id = ?', section_id, proxy_owner.id]
        end
      end
    end
  end

  has_many  :articles do
    def find_by_permalink(options)
      conditions = 
        returning ["(contents.published_at IS NOT NULL AND contents.published_at <= ?)", Time.now.utc] do |cond|
          if options[:year]
            from, to = Time.delta(options[:year], options[:month], options[:day])
            cond.first << ' AND (contents.published_at BETWEEN ? AND ?)'
            cond << from << to
          end
          
          [:id, :permalink].each do |attr|
            if options[attr]
              cond.first << " AND (contents.#{attr} = ?)"
              cond << options[attr]
            end
          end
        end
      
      find :first, :conditions => conditions, :order => 'published_at desc'
    end
  end
  

#  before_validation :downcase_host
#  before_validation :set_default_attributes

  validates_presence_of :name
  validates_presence_of :owner
  validates_presence_of :permalink_style
  validates_presence_of :search_path
  validates_presence_of :tag_path

  validates_format_of     :search_path, :tag_path, :with => Format::STRING


  validate :check_permalink_style

  after_create { |s| s.sections.create(:name => 'Home') }

  with_options :order => 'contents.created_at DESC', :class_name => 'Comment' do |comment|
    comment.has_many :comments,            :conditions => ['contents.approved = ?', true]
    comment.has_many :unapproved_comments, :conditions => ['contents.approved = ? or contents.approved is null', false]
    comment.has_many :all_comments
  end
  
  
 ###
 # Get the lastest n record of a type linked to this project   
 # 
  def lastest(model = Task, count=5)
    if model.columns.any?{|c|c.name=='project_id'} and model.columns.any?{|c|c.name=='updated_at'}
       model.find(:all,:conditions => ['project_id=?',self.id] ,
                  :order=>'updated_at desc',:limit => count)
    elsif model.columns.any?{|c|c.name=='updated_at'}
       model.find(:all, :order=>'updated_at desc',:limit => count)
    else
      model.find(:all,:order=>'id desc',:limit => count)
    end
  end

 
  ##
  # Get all Tags used in the project
  # 
  def tags
    Tag.find(:all, :select      => "DISTINCT tags.name",
                   :joins       => "INNER JOIN taggings ON taggings.tag_id = tags.id INNER JOIN contents ON (taggings.taggable_id = contents.id AND 
                                    taggings.taggable_type = 'Content')",
                   :conditions  => ['contents.type = ? AND contents.project_id = ?', 'Article', id],
                   :order       => 'tags.name')
  end


##
# path for attachmented to be saved under
  def attachment_path
    SystemSetting.get('attachment_path') 
  end


  [:attachments, :templates, :resources].each { |m| delegate m, :to => :theme }


  def permalink_for(article)
    Biorails::Dispatcher.build_permalink_with(permalink_style, article)
  end

  def search_url(query, page = nil)
    "/#{search_path}?q=#{CGI::escapeHTML(query)}#{%(&page=#{CGI::escapeHTML(page.to_s)}) unless page.blank?}"
  end

  def tag_url(*tags)
    ['', tag_path, *tags] * '/'
  end

  def accept_comments?
    comment_age.to_i > -1
  end

  def render_liquid_for(section, template_type, assigns = {}, controller = nil)
    assigns.update('project' => to_liquid(section), 'mode' => template_type)
    parse_inner_template(set_content_template(section, template_type), assigns, controller)
    parse_template(set_layout_template(section, template_type), assigns, controller)
  end

  def to_liquid(current_section = nil)
    SiteDrop.new self, current_section
  end

  composed_of :timezone, :class_name => 'TZInfo::Timezone', :mapping => %w(timezone name)
  
  alias original_timezone_writer timezone=
  
  def timezone=(name)
    name = TZInfo::Timezone.new(name) unless name.is_a?(TZInfo::Timezone)
    original_timezone_writer(name)
  end

  def page_cache_directory
    multi_projects_enabled ? 
      (RAILS_PATH + (RAILS_ENV == 'test' ? 'tmp' : 'public') + 'cache' + host) :
      (RAILS_PATH + (RAILS_ENV == 'test' ? 'tmp/cache' : 'public'))
  end

  def expire_cached_pages(controller, log_message, pages = nil)
    controller = controller.class unless controller.is_a?(Class)
    pages ||= cached_pages.find_current(:all)
    returning cached_log_message_for(log_message, pages) do |msg|
      controller.logger.warn msg if cache_sweeper_tracing
      pages.each { |p| controller.expire_page(p.url) }
      CachedPage.expire_pages(self, pages)
    end
  end

  protected
    def cached_log_message_for(log_message, pages)
      pages.inject([log_message, "Expiring #{pages.size} page(s)"]) { |msg, p| msg << " - #{p.url}" }.join("\n")
    end
  
    def permalink_variable_format?(var)
      Biorails::Dispatcher.variable_format?(var)
    end

    def permalink_variable?(var)
      Biorails::Dispatcher.variable?(var)
    end

    def check_permalink_style
      permalink_style.sub! /^\//, ''
      permalink_style.sub! /\/$/, ''
      pieces = permalink_style.split('/')
      errors.add :permalink_style, 'cannot have blank paths' if pieces.any?(&:blank?)
      pieces.each do |p|
        errors.add :permalink_style, "cannot contain '#{p}' variable" unless p.blank? || permalink_variable_format?(p).nil? || permalink_variable?(p)
      end
      unless pieces.include?(':id') || pieces.include?(':permalink')
        errors.add :permalink_style, "must contain either :permalink or :id"
      end
      if !pieces.include?(':year') && (pieces.include?(':month') || pieces.include?(':day'))
        errors.add :permalink_style, "must contain :year for any date-based permalinks"
      end
    end

    def downcase_host
      self.host = host.to_s.downcase
    end

    def set_default_attributes
      self.permalink_style = ':year/:month/:day/:permalink' if permalink_style.blank?
      self.search_path     = 'search' if search_path.blank?
      self.tag_path        = 'tags'   if tag_path.blank?
      [:permalink_style, :search_path, :tag_path].each { |a| send(a).downcase! }
      self.timezone = 'UTC' if read_attribute(:timezone).blank?
      if new_record?
        self.approve_comments = false unless approve_comments?
        self.comment_age      = 30    unless comment_age
      end
      true
    end
    
  
end
