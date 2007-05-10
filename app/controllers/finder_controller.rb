##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class FinderController < ApplicationController
 
   def search
     @search_text = params['query']
     @hitlist = []
     unless @search_text.empty?
        @hitlist = Project.find_by_contents(@search_text,:models=>:all,:limit=>100)
     end 
   end

   def reindex
     Project.rebuild_index(Study,StudyProtocol,StudyParameter,StudyQueue)
     Project.rebuild_index(Project,ProjectElement,ProjectContent)
     Project.rebuild_index(Experiment,Task)
     Project.rebuild_index(Request,RequestService)
   end
     
end
