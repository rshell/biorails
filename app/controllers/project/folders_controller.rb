class Project::FoldersController < ApplicationController

  use_authorization :project,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights =>  :current_project  
                    
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update ],
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
    respond_to do |format|
      format.html { render :action=>'show'}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages', :partial => 'messages'
           page.replace_html 'data_view',  :partial => 'folder' ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
  end
  
##
# Display the current clipboard 
# 
  def document
    current_folder
    respond_to do |format|
      format.html { render :action=>'document'}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages',   :partial => 'messages'
           page.replace_html 'data_view',  :partial => 'document' ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
  end    

##
# Display the current clipboard 
# 
  def layout
    current_folder
    respond_to do |format|
      format.html { render :action => 'layout', :layout => "layouts/printout.rhtml"}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages',   :partial => 'messages'
           page.replace_html 'data_view',  :partial => 'layout' ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
  end
##
##
# Display the current clipboard 
# 
  def print
    current_folder
    respond_to do |format|
      format.html { render :action => 'print', :layout => "layouts/printout.rhtml"}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages',   :partial => 'messages'
           page.replace_html 'data_view',  :partial => 'print' ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
  end
##
# Display the current clipboard 
# 
  def blog
    current_folder
    respond_to do |format|
      format.html { render :action => 'blog' }
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages',   :partial => 'messages'
           page.replace_html 'data_view',  :partial => 'blog' ,:locals=>{:folder=>@project_folder}
         end
      }
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
    @project_folder = ProjectFolder.new(:name=> Identifier.next_user_ref, 
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
    logger.info "destroy"
    element  = ProjectElement.find(params[:id]) 
    element.destroy
    redirect_to :action => 'show', :id=>element.parent_id
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
   
  
  def add_element   
    @project_folder = ProjectFolder.find(params[:id]) 
    mode = params[:mode] ||'folder'
    text = request.raw_post || request.query_string
    case text
    when /id=project_element_*/ 
        @source = ProjectElement.find($')        
        if @source.id != @project_folder.id and @source.parent_id != @project_folder.id
          @new_element = @project_folder.add(@source)
         flash[:info] = "add reference to #{@source.dom_id} to #{@project_folder.dom_id}"
        end     
     end
     @successful =true
     @project_folder.reload
     respond_to do |format|
      format.html { render :action=> mode }
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages',   :partial => 'messages'
           page.replace_html 'data_view',  :partial => mode ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
  end

  def move_element
    @project_folder = ProjectFolder.find(params[:id]) 
    @project_element =  current(ProjectElement, params[:before] ) 
    mode = params[:mode] ||'folder'
    text = request.raw_post || request.query_string
    case text
    when /id=current_project_element_*/
        @source = ProjectElement.find($') 
        if @source.parent_id == @project_folder.id and @source.id != @project_element.id
          @source.reorder_before( @project_element )
        end     
    end    
    @successful =true
    @project_folder.reload
    respond_to do |format|
      format.html { render :action=> mode }
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages',   :partial => 'messages'
           page.replace_html 'data_view',  :partial => mode ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
  end
  
  
##
# a element has been dropped on the folder
#  
  def drop_element
    @project_folder = ProjectFolder.find(params[:id])
    @project_element =  current(ProjectElement, params[:before] ) 
    mode = params[:mode] ||'folder'
    text = request.raw_post || request.query_string
    @successful =true
    
    case text
    when /id=current_project_element_*/
        @source = ProjectElement.find($') 
        if  @source.id != @project_element.id
          @source.reorder_before( @project_element )
         flash[:info] = "moved reference to #{@source.dom_id} before #{@project_element.dom_id}"
        end     
    
    when /id=project_element_*/ 
        @source = ProjectElement.find($')        
        if allowed_move(@source,@project_element)
          @new_element = @project_folder.add(@source)
          @new_element.reorder_before( @project_element )
         flash[:info] = "added reference to #{@source.dom_id} before #{@project_element.dom_id}"
        end     
    else
      @successful =false
      @source= @project_element
    end
     @project_folder.reload
    respond_to do |format|
      format.html { render :action=> mode }
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'messages',   :partial => 'messages'
           page.replace_html 'data_view',  :partial => mode ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
  end
  
  
protected

  def allowed_move(source,dest)
     return !(source.id == dest.id or source.id == dest.parent_id or  source.parent_id == dest.id  or source.parent_id == dest.parent_id)
  end
##
# Simple helpers to get the current folder from the session or params 
#  
  def current_folder
     current_project
     @project_folder = current(ProjectFolder,params[:folder_id] || params[:id]) 
  end  

end
