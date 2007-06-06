##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class FinderController < ApplicationController
 
   def search
     @search_text = params['query']
     @hitlist = []
     @projects = current_user.projects.collect{|i|i.id}
     unless @search_text.nil? || @search_text.empty?
        @hitlist = Project.find_by_contents(@search_text,:models=>:all,:limit=>100).collect do |item|  
          if item.respond_to?(:project_id)                
             @projects.any?{|a|a == item.project_id} ?   item : nil
          else
             item
          end
        end
        @hitlist = @hitlist.compact
     end 
   end

end
