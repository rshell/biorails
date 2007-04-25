class Project::AssetController < ApplicationController

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
    @project_folder =  current_folder
    render :action => 'show' 
  end
##
# Display a file asset
#   
  def show
    current_project
    @project_element =  current(ProjectElement, params[:id] )  
    @project_asset   = @project_element.reference
    @project_folder   = @project_element.parent
    render :partial => 'asset' ,:locals=>{:asset=> @project_asset}, :layout => false if request.xhr?
  end

##
# Display the file upload file selector
#
  def new
    current_project
    @project_folder =current_folder
    @project_asset = ProjectAsset.new(:title=> Identifier.next_id(ProjectAsset),
                                      :project_id => @project_folder.project_id)
    render :partial => 'upload' ,:locals=>{:folder=> @project_folder}, :layout => false if request.xhr?
  end
##
# File update handler to create a ProjectAsset and link it into the current folder.
#  
  def upload
    current_folder
    @project_asset = ProjectAsset.new(params[:project_asset])
    if @project_asset.save
        asset =  @project_folder.add(@project_asset)
        redirect_to :action => 'upload',:id => @project_folder
    else
        render :action => 'upload',:id => @project_folder
    end
  end 

protected

##
# Simple helpers to get the current folder from the session or params 
#  
  def current_folder
     @project = current_project
     @project_folder = current(ProjectFolder,params[:folder_id] || params[:id]) 
  end  
                    

end
