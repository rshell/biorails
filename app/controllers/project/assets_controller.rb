class Project::AssetsController < ApplicationController

  use_authorization :project,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
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
    @project_asset   = @project_element.asset
    @project_folder   = @project_element.parent
    respond_to do |format|
      format.html { render :action=>'show'}
      format.xml  { render :xml => @project_asset.to_xml(:include=>[:db_file])}
      format.js  { render :update do | page |
           page.replace_html 'centre',  :partial=> 'asset',:locals=>{:asset=> @project_asset}
         end
      }
    end  
    
  end

  def edit
    current_project
    @project_element =  current(ProjectElement, params[:id] )  
    @project_asset   = @project_element.asset
    @project_folder   = @project_element.parent
    respond_to do |format|
      format.html { render :action=>'edit'}
      format.xml  { render :xml => @project_asset.to_xml(:include=>[:db_file])}
      format.js  { render :update do | page |
           page.replace_html 'centre',  :partial=> 'asset',:locals=>{:asset=> @project_asset}
         end
      }
    end  
    
  end

##
# Display the file upload file selector
#
  def new
    current_project
    @project_folder =current_folder
    name = Identifier.next_user_ref 
    @project_element = ProjectElement.new(:name => name ,      
                                          :project_id => @project_folder.project_id)
    
    @project_asset = ProjectAsset.new(:title=> name,
                                      :project_id => @project_folder.project_id)
    respond_to do |format|
      format.html { render :action=>'upload'}
      format.xml  { render :xml => @project_asset.to_xml(:include=>[:project])}
      format.js  { render :update do | page |
           page.replace_html 'message', :partial=> 'messages'
           page.replace_html 'centre',  :partial => 'upload' ,:locals=>{:folder=> @project_folder}
         end
      }
    end  
  end
##
# File update handler to create a ProjectAsset and link it into the current folder.
#  
  def upload
    current_folder
    ProjectFolder.transaction do
      @project_asset = ProjectAsset.new(params[:project_asset])
      if @project_asset.save
          @project_element =  @project_folder.add_asset(@project_asset.filename,@project_asset)
          redirect_to folder_url(:action => 'show',:id => @project_folder)
      else
          logger.warn " Errors #{@project_asset.errors.full_messages.to_sentence}"
          flash[:error] = " Errors #{@project_asset.errors.full_messages.to_sentence}"
          render :action => 'upload',:id => @project_folder
      end
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
