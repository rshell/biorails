class Project::FoldersController < ApplicationController

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
# List of elements in for a folder
# 
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
#  * @project based on folder
# 
  def show
    current_folder
    if request.xhr?
       render :partial => 'folder' ,:locals=>{:folder=>@project_folder}, :layout => false 
    else
       render :action => 'show' 
    end
  end
##
# List of elements in the route home folder
# 
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
#  * @project based on folder
# 
  def new
    @parent = current_folder
    @project_folder = ProjectFolder.new(:name=> Identifier.next_id(ProjectFolder), 
                                        :parent_id=>@parent.id,
                                        :project_id=>@parent.project_id)
    render :partial => 'new' ,:layout => false if request.xhr?
  end
##
# Create a new child folder
# 
#  * @parent based on params[:folder_id] || params[:id] || session[:folder_id]
#  * @project_folder created from module forparams[:project_folder]
# 
  def create
    @parent = current_folder
    @project_folder = @parent.folder(params[:project_folder][:name])
    if @project_folder.save
      flash[:notice] = 'ProjectFolder was successfully created.'
      if request.xhr?
         render :partial => 'folder' ,:locals=>{:folder=> @parent} 
      else
         redirect_to :action => 'show',:id => @parent
      end 
    else
      render :partial => 'new' ,:locals=>{:folder=> @parent}
    end
  end
##
# Edit the current folder details
#
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id] 
# 
  def edit
    current_folder
    render :action => 'edit' ,:layout => false if request.xhr?
  end
##
# Update the current folder details
#
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id] then updated from params[:project_folder]
#
  def update
    current_folder
    if @project_folder.update_attributes(params[:project_folder])
      flash[:notice] = 'ProjectFolder was successfully updated.'
      redirect_to :action => 'show', :id => @project_folder
    else
      render :action => 'edit',:layout => false if request.xhr?
    end
  end
##
# Destroy the the  folder
#
  def destroy
    project_folder =current_folder
    project_folder.destroy
    redirect_to :action => 'list'
  end
##
# Display the selector
#     
  def selector
    current_folder
    render :partial => 'selector',:locals=>{:folder=> @project_folder} ,:layout => false if request.xhr?
  end
##
# Display the current clipboard 
# 
  def clipboard
    current_folder
    render :partial => 'clipboard',:locals=>{:folder=> @project_folder} ,:layout => false if request.xhr?
  end  
##
# Display the current clipboard 
# 
  def document
    current_folder
    render :partial => 'document',:locals=>{:folder=> @project_folder} ,:layout => false if request.xhr?
  end    

##
# Display the current clipboard 
# 
  def print
    current_folder
    render :action => 'print', :layout => "layouts/printout.rhtml"
  end
##
# Display the current clipboard 
# 
  def blog
    current_folder
    render :partial => 'blog',:locals=>{:folder=> @project_folder} ,:layout => false if request.xhr?
  end      
##
# Display a file asset
#   
  def asset
    current_project
    @project_element =  current(ProjectElement, params[:id] )  
    @project_asset   = @project_element.reference
    @project_folder   = @project_element.parent
    render :partial => 'asset' ,:locals=>{:asset=> @project_asset}, :layout => false if request.xhr?
  end

##
# Display the file upload file selector
#
  def new_asset
    current_project
    @project_folder =current_folder
    @project_asset = ProjectAsset.new(:title=> Identifier.next_id(ProjectAsset),
                                      :project_id => @project_folder.project_id)
    render :partial => 'upload' ,:locals=>{:folder=> @project_folder}, :layout => false if request.xhr?
  end
##
# File update handler to create a ProjectAsset and link it into the current folder.
#  
  def upload_asset
    @project_folder =current_folder
    @project_asset = ProjectAsset.new(params[:project_asset])
    if @project_asset.save
        asset =  @project_folder.add(@project_asset)
        redirect_to :action => 'upload',:id => @project_folder
    else
        render :action => 'upload',:id => @project_folder
    end
  end 
## 
# Display a article for editing
# 
  def article
    @project_element = current(ProjectElement, params[:id] )  
    @project_content   = @project_element.reference
    @project_folder =@project_element.parent
    render :partial => 'article' ,:locals=>{:content=> @project_content}, :layout => false if request.xhr?
  end
##
# Display the current clipboard 
# 
  def new_article
    @project_folder =current_folder
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
  def save_article
    @project_folder  =current_folder
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
  def update_article
     current_project
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
