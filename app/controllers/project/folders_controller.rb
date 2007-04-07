class Project::FoldersController < ApplicationController

  uses_tiny_mce(:options => {
     :theme => 'advanced',
     :browsers => %w{msie,gecko,opera,safari},
     :theme_advanced_toolbar_location => "top",
     :theme_advanced_toolbar_align => "left",
     :auto_resize => false,
     :theme_advanced_resizing => true,
     :theme_advanced_statusbar_location => "bottom",
     :paste_auto_cleanup_on_paste => true,
     :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent bullist numlist separator fullscreen help},
     :theme_advanced_buttons2 => %w{cut copy paste pastetext pasteword undo redo link unlink image separator visualaid tablecontrols separator fullpage code cleanup},
     :theme_advanced_buttons3 => [],
     :plugins => %w{contextmenu paste table fullscreen fullpage}
     },
      :only => [:new, :edit, :show,:article, :new_article, :index])  
 
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
    @project = current_project
    @project_folder = @project.folders.home
    render :action => 'show'
  end
##
# List of elements in for a folder
# 
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
#  * @project based on folder
# 
  def show
    @project_folder =current_folder
    render :partial => 'folder' ,:locals=>{:folder=>@project_folder}, :layout => false if request.xhr?
  end
##
# List of elements in the route home folder
# 
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
#  * @project based on folder
# 
  def new
    @parent = current_folder
    @project_folder = ProjectFolder.new(:parent_id=>@parent.id,:project_id=>@parent.project_id)
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
    @project_folder =current_folder
    render :action => 'edit' ,:layout => false if request.xhr?
  end
##
# Update the current folder details
#
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id] then updated from params[:project_folder]
#
  def update
    @project_folder =current_folder
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
# Display the file upload file selector
#
  def new_asset
    @project_folder =current_folder
    @project_asset = ProjectAsset.new
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
# Display the selector
#     
  def selector
    @project_folder =current_folder
    render :partial => 'selector',:locals=>{:folder=> @project_folder} ,:layout => false if request.xhr?
  end
##
# Display the current clipboard 
# 
  def clipboard
    @project_folder =current_folder
    render :partial => 'clipboard',:locals=>{:folder=> @project_folder} ,:layout => false if request.xhr?
  end  
##
# Display the current clipboard 
# 
  def document
    @project_folder =current_folder
    render :partial => 'document',:locals=>{:folder=> @project_folder} ,:layout => false if request.xhr?
  end    
##
# Display the current clipboard 
# 
  def blog
    @project_folder =current_folder
    render :partial => 'blog',:locals=>{:folder=> @project_folder} ,:layout => false if request.xhr?
  end      
##
# Display a file asset
#   
  def asset
    @project_asset   = current(ProjectAsset,   params[:asset_id] )   
    @project_element = current(ProjectElement, params[:element_id] )  
    @project_folder =@project_element.parent
  end

## 
# Display a article for editing
# 
  def article
    @project_content   = current(ProjectContent,   params[:content_id] )   
    @project_element = current(ProjectElement, params[:element_id] )  
    @project_folder =@project_element.parent
  end
##
# Display the current clipboard 
# 
  def new_article
    @project_folder =current_folder
    @project_content = ProjectContent.new(:project_id => @project_folder.project_id)
    if request.xhr?
       render :partial => 'article', :locals=>{:content=> @project_content} ,:layout => false 
    else
       render :action => 'article',:locals=>{:folder=> @project_folder}
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
        redirect_to :action => 'show',:id => @project_folder
    else
        logger.warning @project_content.to_yaml
        render :action => 'article', :id => @project_folder
    end
  end

##
# Save a article
# 
  def update_article
    @project_content = current(ProjectContent,   params[:content_id] )   
    @project_element = current(ProjectElement, params[:element_id] )     
    if  @project_content.update_attributes(params[:project_content])
        redirect_to :action => 'show',:id => @project_folder
    else
        logger.warning @project_content.to_yaml
        render :action => 'article', :id => @project_folder
    end
  end


protected

##
# Simple helpers to get the current folder from the session or params 
#  
  def current_folder
     folder = current(ProjectFolder,params[:folder_id] || params[:id]) 
     @project =folder.project
     return folder
  end  
 
 def current_element
     element = current(ProjectElement, params[:element_id] || params[:id]) 
     @project =element.project
     return element
  end   

 def current_asset
     asset = current(ProjectAsset,params[:asset_id] || params[:id]) 
     return asset
  end   

end
