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
        @hitlist = ProjectElement.find(:all, :conditions=>['lower(name) like ?',"#{@search_text.downcase}%"],:limit=>50)
        if @hitlist.size==0
          @hitlist = ProjectElement.find(:all,:include=>:content,
            :conditions=>['body_html like ?',"%#{@search_text}%"],:limit=>50)
        end
      end 
    respond_to do | format |
      format.html { render :partial => 'search', :layout=>false }
      format.xml  { render :xml => {:text=>@search_text,:items=>@hitlist}.to_xml }
      format.js  { render :update do | page |  
            page.main_panel :partial => 'search'
         end 
      }
    end
   end

  def add_clipboard
    @project_element = ProjectElement.find(params[:id])
    @clipboard.add(@project_element);
    save_clipboard @clipboard
    respond_to do | format |
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
      format.html { render :partial => 'shared/clipboard' }
      format.js  { render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
    end    
  end  


 
end
