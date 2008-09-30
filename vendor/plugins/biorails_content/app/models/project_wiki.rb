# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class ProjectWiki < ProjectContent
   validates_associated :content

  def icon( options={} )
     '/images/model/note.png'
  end  

  def self.view_root
    File.dirname(__FILE__)+'/../views/project_wiki'
  end
  
 #
  # Fill the content of the project element
  #
  def fill(item)
    case item
    when Hash
      self.name = item[:name]      
      self.title = item[:title]      
      update_content(item[:data])  unless item[:data].blank?     
    when String
      update_content(item)      
    end
  end
  
  #
  # Process the body to generate a html version
  #
  def process(data)
     RedCloth.new(data).to_html
  end

  #
  # Style for the element
  #
  def style
    'html'
  end
  #
  # Set the Data from a form
  #
  def content_data=(value)
    fill(data)
  end
  #
  # Set the Content Data for use in forms
  #
  def content_data
    content.body if content    
  end

end
