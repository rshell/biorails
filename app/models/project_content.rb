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
  validates_presence_of :content_id
  
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
    element.position =  options[:position]
    element.project_id= options[:project_id]
    
    content = Content.new
    content.name =         Identifier.next_id(Content)
    content.title =        options[:title]      
    content.body      =    options[:body]        
    content.project_id=    options[:project_id]
    content.body_html =    options[:to_html]  
    content.valid?
    logger.info content.to_yaml
    return self unless content.save
    element.content = content
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
      return self unless self.content.save      
      self.content.move_to_child_of(old)  
    end
  end
##
# Single line title
#
  def title
   self.content.title if content
  end 
##
# Html report version
#
  def to_html
    self.content.body_html if content
  end
##
# Textual content  

  def description
     return "" unless content
     text = ""
     tokenizer = HTML::Tokenizer.new(to_html)
      while token = tokenizer.next
         node = HTML::Node.parse(nil, 0, 0, token, false)
         text << node.to_s if node.class == HTML::Text  
      end
      return text.gsub(/<!--(.*?)-->[\n]?/m, "") 
  end
##
# Summay of the content

  def summary
     return content.summary if content
     return name
  end         

  def icon( options={} )
     '/images/model/note.png'
  end  
  

end
