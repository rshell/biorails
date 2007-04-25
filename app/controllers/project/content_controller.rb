class Project::ContentController < ApplicationController

  use_authorization :project,
                    :actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
                    :rights =>  :current_project  

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

##
# List of elements in the route home folder
# 
#  * @project based on current context params[:project_id] || params[:id] || session[:project_id]
#  * @project_folder based on home folder for project
# 
  def list
    @project_folder =  current_project.home
    render :action => 'show' 
  end
## 
# Display a article for editing
# 
  def show
    current_folder
    @project_element = current(ProjectElement, params[:id] )  
    @project_content   = @project_element.reference
    @project_folder =@project_element.parent
    render :partial => 'article' ,:locals=>{:content=> @project_content}, :layout => false if request.xhr?
  end
##
# Display the current clipboard 
# 
  def new
    current_folder
    @project_content = ProjectContent.new(:name => Identifier.next_id(ProjectContent),      
                                          :project_id => @project_folder.project_id)
    if request.xhr?
       render :partial => 'article', :locals=>{:content=> @project_content} ,:layout => false 
    else
       render :action => 'article'
    end
  end
##
# Save a article
# 
  def create
    current_folder
    @project_content = ProjectContent.new(params[:project_content])
    if @project_content.save
        @project_element = @project_folder.add(@project_content)
        if request.xhr?
           render :partial => 'folder', :locals=>{:folder=> @project_folder} ,:layout => false 
        else
           redirect_to :action => 'show',:id => @project_folder
        end
    else
        logger.warning @project_content.to_yaml
        render :action => 'article', :id => @project_folder
    end
  end

##
# Save a article
# 
  def update
     current_folder
     @project_element = current(ProjectElement,params[:id] )     
     @project_folder  = @project_element.parent
     @project_content = @project_element.reference
     unless @project_content.update_attributes(params[:project_content])
          logger.warning "problems in save on content"
          logger.warning " Errors #{@user.errors.full_messages.to_sentence}"
          flash[:error] = "failed to save content"
          logger.info @project_content.to_yaml
     end
     if request.xhr?
        render :partial => 'folder', :locals=>{:folder=> @project_folder} ,:layout => false 
     else
        redirect_to :action => 'show', :id => @project_folder
     end
  end


protected

##
# Simple helpers to get the current folder from the session or params 
#  
  def current_folder
     current_project
     @project_folder = current(ProjectFolder,params[:folder_id] || params[:id]) 
  end  
                    

end
