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
class ProjectContent < ProjectElement
                
  validates_associated :content
  
#  def before_save
#    self.content.save if self.content
#  end
  
#
# Build a New ProjectConent item 
#
  def ProjectContent.build(options ={})
    options = options.symbolize_keys()

    element = ProjectContent.new
    element.reference = options[:reference] 
    element.name =      options[:name] || options[:title] 
    element.path =      options[:path]
    element.position =  options[:position]
    element.project_id= options[:project_id]
    
    element.content = Content.new
    element.content.name =         Identifier.next_id(Content)
    element.content.title =        options[:title]      
    element.content.body      =    options[:body]        
    element.content.project_id=    options[:project_id]
    element.content.body_html =    options[:to_html]   
    return element
  end
#
# Update the content of the element added a new content
# entry and linking it previous version
#
  def update_element(options)
    Content.transaction do
      old = Content.find(self.content_id)
      self.content = Content.new
      self.content.name       =  old.name || options[:name]       
      self.content.title      =  options[:title]      
      self.content.body       =  options[:body]        
      self.content.project_id =  self.project_id   
      self.content.body_html  =  options[:to_html] 
      return self unless self.content.valid?
      self.content.save
      self.content.move_to_child_of(old)  
    end
  end

  def title
   self.content.title if content
  end
  
  
  def to_html
    self.content.body_html if content
  end
##
# Textual content  

  def description
    return to_html 
  end

  def icon( options={} )
     '/images/model/note.png'
  end  
  
  def summary
     return content.summary if content
     return name
  end         

end
