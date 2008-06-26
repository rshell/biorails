class ProjectElementDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes << :path  << :parent << :children << :reference << :project  << :team <<  :reference << :summary << :title << :icon
 
 def initialize(source,options={})
   super source
    @options  = options
 end
 
 def folder_content
   @source.children.collect{|i|i.to_html}.join("\n")
 end
 
 def content
   if @source.content
     liquify(@source.content.body_html)
   elsif @source.asset
     liquify(@source.description)
   elsif @source.reference
     liquify(@source.reference.to_html)
   end  
 end
 
 def image
   @source.image_tag
 end

 def dom_id
   @source.dom_id
 end
 
 def assert_path
    asset.public_filename
 end
 
 def asset_url
   liquify(@source.url) 
 end
 
 def is_signed
   liquify(@source.signed?) 
 end
 
 protected

end
