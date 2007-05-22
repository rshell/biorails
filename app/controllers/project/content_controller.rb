class Project::ContentController < ApplicationController

  use_authorization :project,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights =>  :current_project  

  def index
    show
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

## 
# Display a article
# 
  def show
    load_contents
    respond_to do |format|
      format.html { render :action=>'show'}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages', :partial=> 'messages'
           page.replace_html 'centre',  :partial=> 'show'
         end
      }
    end  
  end

##
# Edit a article 
# 
  def edit
   load_contents
   respond_to do |format|
      format.html { render :action=>'edit'}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content])}
      format.js  { render :update do | page |
           page.replace_html 'messages', :partial=> 'messages'
           page.replace_html 'centre',  :partial=> 'edit'
         end
      }
    end  
  end

##
# Display the current clipboard 
# 
  def new
    load_folder
    @project_element = ProjectElement.new(:name => Identifier.next_user_ref,      
                                          :project_id => @project_folder.project_id)
                                          
    @project_content = ProjectContent.new(:name => @project_element.name,      
                                          :project_id => @project_folder.project_id)
    respond_to do |format|
      format.html { render :action=>'new'}
      format.xml  { render :xml => @project_content.to_xml(:include=>[:project])}
      format.js  { render :update do | page |
           page.replace_html 'messages', :partial=> 'messages'
           page.replace_html 'centre',  :partial=> 'new'
         end
      }
    end  
  end
##
# Save a article
# 
  def create
    load_folder
    @project_element = @project_folder.add_content(params[:project_element][:name],params[:project_content][:title],params[:project_content][:body_html])    
    @project_element.tag_list = params[:project_element][:tag_list]

    if @project_element.save
        respond_to do |format|
          format.html { redirect_to folder_url(:action => 'show', :id => @project_folder) } 
          format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset])}
          format.js  { render :update do | page |
               page.replace_html 'messages', :partial=> 'messages'
               page.replace_html 'centre',  :partial=> 'show'
             end
          }
        end  
    else
        render :action => 'new', :id => @project_folder
    end

  rescue Exception => ex
      flash[:error] = ex.message
      logger.error ex.backtrace.join("\n")    
      render :action => 'new', :id => @project_folder
      
  end

##
# Save a article
# 
  def update
     load_contents
     if @project_content.update_attributes(params[:project_content]) and @project_element.update_attributes(params[:project_element])
         respond_to do |format|
            format.html { redirect_to folder_url(:action => 'show', :id => @project_folder) } 
            format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset])}
            format.js  { render :update do | page |
                 page.replace_html 'messages', :partial=> 'messages'
                 page.replace_html 'centre',  :partial=> 'show'
               end
            }
         end  
     else
        logger.error "problems in save on content"
        logger.error " Errors #{@project_element.errors.full_messages.to_sentence}"
        flash[:error] = "failed to save content"
        logger.info @project_content.to_yaml
        render :action => 'new', :id => @project_folder
     end
  end


protected
##
# Load the contents
# 
  def load_contents
     @project = current_project
     @project_element = current(ProjectElement, params[:id] )  
     @project_content   = @project_element.content
     @project_folder  = @project_element.parent    
  end
##
# Simple helpers to get the current folder from the session or params 
#  
  def load_folder
     @project = current_project
     @project_folder = ProjectFolder.find(params[:folder_id]||params[:id]) 
  end  
                    

end
