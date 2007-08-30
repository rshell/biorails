class Project::ContentController < ApplicationController

  use_authorization :folders,
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
    @project_element = current_user.element(params[:id])  
    @project_folder  = @project_element.parent    
    respond_to do |format|
      format.html { render :action=>'show'}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages', :partial=> 'messages'
           page.replace_html  @project_element.dom_id(:current), :partial=> 'show'
         end
      }
    end  
  end

  def diff
    @project_element = current_user.element(params[:id])  
    @project_folder  = @project_element.parent    
    @this = @project_element.content
    @other = Content.find(params[:version])
    @diff = @other.body_html 
    respond_to do |format|
      format.html { render :action=>'diff'}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages', :partial=> 'messages'
           page.replace_html 'diff',  :partial=> 'diff'
         end
      }
    end      
  end
##
# Display the current clipboard 
# 
  def new
    load_folder
    @project_element = ProjectContent.new(:name => Identifier.next_user_ref,      
                                          :project_id => @project_folder.project_id)
    respond_to do |format|
      format.html { render :action=>'new'}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:project])}
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
    ProjectElement.transaction do
      @project_element = @project_folder.add_content(params[:project_element][:name],params[:project_element][:title],
                                                     params[:project_element][:to_html])   
      logger.info @project_element.to_yaml
      @project_element.valid?
      unless @project_element.save
           flash[:error] = "Validation failed  #{@project_element.content.errors.full_messages.to_sentence} #{@project_element.errors.full_messages.to_sentence}"
           respond_to do |format|
            format.html { render :action=>'new'}
            format.xml  { render :xml => @project_element.to_xml(:include=>[:project])}
            format.js  { render :update do | page |
                 page.replace_html 'messages', :partial=> 'messages'
                 page.replace_html 'centre',  :partial=> 'new'
               end
            }
          end 
     else   
          respond_to do |format|
            format.html { redirect_to folder_url(:action => 'show', :id => @project_folder) } 
            format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset])}
            format.js  { render :update do | page |
                 page.replace_html 'messages', :partial=> 'messages'
                 page.replace_html 'centre',  :partial=> 'show'
               end
            }
          end  
     end
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
           page.replace_html  @project_element.dom_id(:current), :partial=> 'edit'
         end
      }
    end  
  end

##
# Save a article
# 
  def update
   @project_element = current_user.element(params[:id], :include=>[ :parent, :content])
   ProjectElement.transaction do
     @project_folder  = @project_element.parent    
     @project_element.update_element(params[:project_element])
     unless @project_element.save
        logger.error " Errors #{@project_element.errors.full_messages.to_sentence}"
        flash[:error] = "failed to save content"
     end
   end
   respond_to do |format|
      format.html { redirect_to folder_url(:action => 'show', :id => @project_folder) } 
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset])}
      format.js  { render :update do | page |
           page.replace_html 'messages', :partial=> 'messages'
           page.replace_html  @project_element.dom_id(:current), :partial=> 'show'
         end
      }
   end  
  end


protected
##
# Load the contents
# 
  def load_contents
     @project_element = current_user.element(params[:id] )  
     @project_folder  = @project_element.parent    
  end
##
# Simple helpers to get the current folder from the session or params 
#  
  def load_folder
     @project_folder = current_user.folder(params[:folder_id]||params[:id]) 
  end  
                    

end
