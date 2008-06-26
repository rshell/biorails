##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class Project::AssetsController < ApplicationController

  use_authorization :project,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights =>  :current_project  
  
  before_filter :setup_folder,    :only => [ :index,:list,:new,:upload]
  before_filter :setup_asset,    :only => [ :show, :edit, :update]

  in_place_edit_for :project_asset, :title
  in_place_edit_for :project_asset, :description

##
# List of elements in the route home folder
# 
#  * @project based on current context params[:project_id] || params[:id] || session[:project_id]
#  * @project_folder based on home folder for project
# 
  def index
    redirect_to folder_url(:action => 'show', :id => @project_folder)
  end

  def list
    redirect_to folder_url(:action => 'show', :id => @project_folder)
  end

##
# Display a file asset
#   
  def show
    respond_to do |format|
      format.html { render :action=>'show'}
      format.ext { render :partial=>'show'}
      format.xml  { render :xml => @project_asset.to_xml()}
      format.js  { render :update do | page |
            page.main_panel   :partial=> 'show'
         end
      }
    end     
  end

  def edit
    respond_to do |format|
      format.html { render :action=>'edit'}
      format.xml  { render :xml => @project_asset.to_xml(:include=>[:db_file])}
      format.js  { render :update do | page |
           page.status_panel :partial => 'shared/messages', :locals => { :objects => ['project_folder','project_asset']} 
           page.main_panel   :partial=> 'edit'
         end
      }
    end   
  end

##
# Save a article
# 
  def update
   ProjectElement.transaction do
     @project_asset.name = params[:project_asset][:name]
     @project_asset.asset.title = params[:project_asset][:title]
     @project_asset.asset.description =params[:project_asset][:description]
     @project_asset.save
   end
   respond_to do |format|
      format.html { redirect_to folder_url(:action => 'show', :id => @project_folder) } 
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset])}
      format.js  { render :update do | page |
           page.status_panel :partial => 'shared/messages', :locals => { :objects => ['project_folder','project_asset']} 
           page.replace_html 'center',  :partial=> 'show'
         end
      }
   end  
  end

##
# Display the file upload file selector
#
  def new
    @project_asset = ProjectAsset.build({ :name=> Identifier.next_user_ref, :project_id => @project_folder.project_id} )    
    respond_to do |format|
      format.html { render :action=>'new'}
      format.xml  { render :xml => @project_asset.to_xml(:include=>[:project])}
      format.js  { render :update do | page |
           page.status_panel :partial => 'shared/messages', :locals => { :objects => ['project_folder','project_asset']} 
           page.help_panel   :partial=> 'help'
           page.main_panel   :partial=> 'upload'
         end
      }
    end  
  end
##
# File update handler to create a ProjectAsset and link it into the current folder.
#  
  def upload
    current_folder
    @ok =false
    begin
      ProjectFolder.transaction do
        @project_asset =  @project_folder.add( ProjectAsset.build(params['project_asset']) )
        session.data[:current_params]=nil   
        @ok = @project_asset.save
        logger.warn flash[:warning] = " Errors #{@project_asset.asset.errors.full_messages.to_sentence}" unless @ok
      end
    rescue Exception => ex
      logger.error ex.message
      logger.debug ex.backtrace.join("\n") 
      flash[:error] = "Error in upload "+ex.message
    end
    if @ok
        redirect_to asset_url(:action => 'new',:id => @project_folder)  
    else
       render( :action => 'new',:folder_id => @project_folder)
    end
    
  end 

protected

##
# Simple helpers to get the current folder from the session or params 
#  
  def setup_folder
     @project = current_project
     @project_folder = current_user.folder(params[:folder_id]) if params[:folder_id]
     @project_folder ||= current_user.folder(params[:id]) if params[:id]
     @project_folder ||= current_folder
  end  
                    
  def setup_asset
     @project_asset =  current_user.element( params[:id] )  
     @project_folder   = @project_asset.parent
  end  
      
end
