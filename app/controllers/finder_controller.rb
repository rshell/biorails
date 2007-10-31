##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
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
      format.html { render :action => 'search', :layout=>false }
      format.js   { render :action => 'search', :layout=>false }
      format.json { render :json => {:text=>@search_text,:items=>@hitlist}.to_json }
      format.xml  { render :xml => {:text=>@search_text,:items=>@hitlist}.to_xml }
    end
   end

##
# Display the current clipboard 
# 
  def finder
    @hits = []
    load_clipboard
    @user_query = params['query'] 
    logger.info "query before [#{@user_query}]"
    ids = current_user.projects.collect{|i|i.id.to_s}.join(",")
    if @user_query
       @query = "#{@user_query}"
       @hits = ProjectElement.find(:all,
          :conditions=>["project_id in (#{ids}) and name like ?","#{@query}%"],
          :order=>"abs(project_id-#{current_project.id}) asc,parent_id,name",:limit=>100)
       if @hits.size==0
         @hits = ProjectElement.find_by_contents(@query,:models=>[ProjectContent,ProjectAsset,ProjectElement,ProjectReference,ProjectFolder],:limit=>100)
       end
    end
    logger.info "query after [#{@query}]"
    return render_right('finder')
  end  
  
  def add_clipboard
    @project_element = ProjectElement.find(params[:id])
    load_clipboard
    @clipboard.add(@project_element);
    save_clipboard @clipboard
    respond_to do | format |
      format.html { render :partial => 'shared/clipboard' }
      format.js  { render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
      format.json { render :json => @clipboard.to_json }
      format.xml  { render :xml => @clipboard.to_xml }
    end
  end

  def remove_clipboard
    @project_element = ProjectElement.find(params[:id])
    load_clipboard
    @clipboard.remove(@project_element);
    save_clipboard @clipboard
    respond_to do | format |
      format.html { render :partial => 'shared/clipboard' }
      format.js  { render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
      format.json { render :json => @clipboard.to_json }
      format.xml  { render :xml => @clipboard.to_xml }
    end    
  end
  
  def clear_clipboard
    save_clipboard @clipboard = Clipboard.new    
    respond_to do | format |
      format.html { render :partial => 'shared/clipboard' }
      format.js  { render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
      format.json { render :json => @clipboard.to_json }
      format.xml  { render :xml => @clipboard.to_xml }
    end    
  end
  
#
# get the clipboard for the current user 
#
  def clipboard
    load_clipboard
    respond_to do | format |
      format.html { render :partial => 'shared/clipboard' }
      format.js  { render :update do | page |  
            page.work_panel :partial => 'shared/clipboard'
         end 
      }
      format.json { render :json => @clipboard.to_json }
      format.xml  { render :xml => @clipboard.to_xml }
    end    
  end  


 
end
