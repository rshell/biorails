# == Project Element Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * folder_content
# * content
# * image
# * dom_id
# * assert_path
# * asset_url
# * is_signed
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
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
   @source.children.collect{|i|i.html if i.state.level_no>=0}.join("\n")
 end
 
 def html
   liquify(@source.html)
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
