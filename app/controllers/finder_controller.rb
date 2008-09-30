# == Description
# This manages the clipboard and free text search functions
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class FinderController < ApplicationController
 
   def search
     @search_text = params['query']||params['text']
     @hitlist = []
     @projects = current_user.projects.collect{|i|i.id}
     unless @search_text.nil? || @search_text.empty?
        @hitlist = Project.find_by_contents(@search_text,:models=>:all,:limit=>50).collect do |item|  
          if item.respond_to?(:project_id)                
             @projects.any?{|a|a == item.project_id} ?   item : nil
          else
             item
          end
        end
        @hitlist = @hitlist.compact
      end 
    respond_to do | format |
      format.html { render :partial => 'search', :layout=>false }
      format.json { render :json => {:text=>@search_text,:items=>@hitlist}.to_json }
      format.xml  { render :xml => {:text=>@search_text,:items=>@hitlist}.to_xml }
      format.js  { render :update do | page |  
            page.status_panel :partial => 'search'
         end 
      }
    end
   end

  def add_clipboard
    @project_element = ProjectElement.find(params[:id])
    @clipboard.add(@project_element);
    save_clipboard @clipboard
    respond_to do | format |
      format.json { render :json => @clipboard.to_json }
      format.html { render :partial => 'shared/clipboard' }
      format.js  { render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
    end
  end

  def remove_clipboard
    @project_element = ProjectElement.find(params[:id])
    @clipboard.remove(@project_element);
    save_clipboard @clipboard
    respond_to do | format |
      format.json { render :json => @clipboard.to_json }
      format.html { render :partial => 'shared/clipboard' }
      format.js  { render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
    end    
  end
  
  def clear_clipboard
    save_clipboard @clipboard = Clipboard.new    
    respond_to do | format |
      format.json { render :json => @clipboard.to_json }
      format.html { render :partial => 'shared/clipboard' }
      format.js  { 
        render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
    end    
  end
  
#
# get the clipboard for the current user 
#
  def clipboard
    respond_to do | format |
      format.json { render :json => @clipboard.to_json }
      format.html { render :partial => 'shared/clipboard' }
      format.js  { render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
    end    
  end  


 
end
