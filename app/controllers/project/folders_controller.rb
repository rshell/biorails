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
    redirect_to :action => 'show' ,:id=>current_project.home
  end
##
# List of elements in for a folder
# 
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
#  * @project based on folder
# 
  def show
    set_folder
    return render_central('show')
  end
  
##
# Display the current clipboard 
# 
  def document
    set_folder
    return render_central('document')
  end    

##
# Display the current clipboard 
# 
  def layout
    set_folder
    return render_central('layout')
  end
##
##
# Display the current clipboard 
# 
  def print
    set_folder
    respond_to do |format|
      format.html { render :action => 'print', :layout => "layouts/printout.rhtml"}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'create',  :partial => 'print' ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
  end
##
# Display the current clipboard 
# 
  def blog
    set_folder
    return render_central('blog')
  end    

##
# Display the selector
#     
  def selector
    set_folder
    return render_right('tree')
  end
##
# Display the current clipboard 
# 
  def clipboard
    set_folder
    return render_right('clipboard')
  end  

##
# Display the current clipboard 
# 
  def finder
    set_folder
    @hits = []
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
   
    
##
# List of elements in the route home folder
# 
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
#  * @project based on folder
# 
  def new
    @parent =  set_folder
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
    @project_folder = set_folder
    @child_folder = @project_folder.folder(params[:project_folder][:name])
    if @child_folder.save
      flash[:notice] = 'ProjectFolder was successfully created.'
      @layout[:centre]= 'show'
    else
      flash[:error] = 'ProjectFolder creation failed.'
      @layout[:centre]= 'new'
    end
    return render_central    
  end
##
# Edit the current folder details
#
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id] 
# 
  def edit
    set_folder
    render :action => 'edit' ,:layout => false if request.xhr?
  end
##
# Update the current folder details
#
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id] then updated from params[:project_folder]
#
  def update
    set_folder
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

  def move_element
    set_folder
    @project_element =  current(ProjectElement, params[:before] ) 
    text = request.raw_post || request.query_string
    case text
    when /id=current_project_element_*/,
         /id=current_project_folder_*/,
         /id=current_project_reference_*/,
         /id=current_project_content_*/,
         /id=current_project_asset_*/
        @source = ProjectElement.find($') 
        if @source.parent_id == @project_folder.id and @source.id != @project_element.id
          @source.reorder_before( @project_element )
        end     
    end    
    @project_folder.reload
    return render_central
  end
  
  def add_element   
    set_folder
    text = request.raw_post || request.query_string
    case text
    when /id=project_element_*/,
         /id=project_content_*/ ,
         /id=project_asset_*/ ,
         /id=project_reference_*/  
        @source = ProjectElement.find($')        
        if @source.id != @project_folder.id and @source.parent_id != @project_folder.id
          @new_element = @project_folder.copy(@source)
         flash[:info] = "add reference to #{@source.dom_id} to #{@project_folder.dom_id}"
        end     
     end
     @project_folder.reload
     return render_central
  end

  
##
# a element has been dropped on the folder
#  
  def drop_element
    set_folder
    @project_element =  current(ProjectElement, params[:before] ) 
    text = request.raw_post || request.query_string
    @successful =true
    
    case text
    when /id=current_project_element_*/,
         /id=current_project_folder_*/,
         /id=current_project_reference_*/,
         /id=current_project_content_*/,
         /id=current_project_asset_*/
        @source = ProjectElement.find($') 
        if  @source.id != @project_element.id
          @source.reorder_before( @project_element )
         flash[:info] = "moved reference to #{@source.dom_id} before #{@project_element.dom_id}"
        end     
    
    when /id=project_element_*/,
         /id=project_content_*/ ,
         /id=project_asset_*/ ,
         /id=project_reference_*/ 
        @source = ProjectElement.find($')        
        if allowed_move(@source,@project_element)
          @new_element = @project_folder.copy(@source)
          @new_element.reorder_before( @project_element )
         flash[:info] = "added reference to #{@source.dom_id} before #{@project_element.dom_id}"
        end     
    else
      @successful =false
      @source= @project_element
    end
     @project_folder.reload
     return render_central
  end
  
##
# Autocomplete for a data element lookup return a list of matching records.
# This is simple helper for lots of forms which want drop down lists of items
# controller from the central catalog.
# 
#  * url is in the form /data_element/choices/n with value=xxxx parameter
#
  def choices
    text = request.raw_post || request.query_string
    @value = text.split("=")[1]
    @choices = ProjectElement.find(:all,
                                :conditions=>['project_id=? and name like ? ', current_project.id, "#{@value}%"],
                                :order=>"abs(#{params[:id]} - parent_id) asc,parent_id,name",
                                :limit=>10)

    render :inline => "<%= auto_complete_result(@choices, 'name') %>"
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      render :partial =>'shared/messages',:locals => { :objects => ['data_element','data_value'] }
  end    
  
  
protected

  def allowed_move(source,dest)
     return !(source.id == dest.id or source.id == dest.parent_id or  source.parent_id == dest.id  or source.parent_id == dest.parent_id)
  end

  def render_central(mode =nil)
    @layout[:centre] = mode if mode
    respond_to do |format|
      format.html { render :action=> @layout[:centre] || 'show'}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'centre',  :partial => @layout[:centre] ,:locals=>{:folder=>@project_folder}
           page.replace_html 'messages',:partial => 'shared/messages', :locals => { :objects => ['project','project_folder','project_element','project_content']}
         end
      }
    end      
  end

  def render_right(mode = nil)
    @layout[:right] ="right_#{mode}" if mode
    respond_to do |format|
      format.html { render :action=>'show'}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'right',  :partial => @layout[:right] ,:locals=>{:folder=>@project_folder}
         end
      }
    end      
  end
##
# Simple helpers to get the current folder from the session or params 
#  
  def set_folder
     @layout = {}
     @layout[:right] = params[:right] || 'right_finder'
     @layout[:centre] = params[:centre] || 'folder'     
     @project_folder = current_user.folder(params[:folder_id] || params[:id]) ||  current_project.home
  end  

end
