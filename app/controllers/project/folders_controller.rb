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
    return render_central('folder')
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
    @user_query = params[:query]
    @query = @user_query.dup
    logger.info "query before [#{@query}]"
    ids = current_user.projects.collect{|i|i.id.to_s}.join(",")
    if @query
       @hits = ProjectElement.find(:all,
          :conditions=>["project_id in (#{ids}) and name like ?","#{@query}%"],
          :order=>"abs(project_id-#{current_project.id}) asc,parent_id,name",:limit=>100)
    end
    if @hits.size==0
       @hits = ProjectElement.find_by_contents(@query.to_s,:limit=>100)
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
    @parent = set_folder
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

  def add_element   
    set_folder
    text = request.raw_post || request.query_string
    case text
    when /id=project_element_*/ 
        @source = ProjectElement.find($')        
        if @source.id != @project_folder.id and @source.parent_id != @project_folder.id
          @new_element = @project_folder.add(@source)
         flash[:info] = "add reference to #{@source.dom_id} to #{@project_folder.dom_id}"
        end     
     end
     @project_folder.reload
     return render_central
  end

  def move_element
    set_folder
    @project_element =  current(ProjectElement, params[:before] ) 
    text = request.raw_post || request.query_string
    case text
    when /id=current_project_element_*/
        @source = ProjectElement.find($') 
        if @source.parent_id == @project_folder.id and @source.id != @project_element.id
          @source.reorder_before( @project_element )
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
     return render_central
  end
  
  
protected

  def allowed_move(source,dest)
     return !(source.id == dest.id or source.id == dest.parent_id or  source.parent_id == dest.id  or source.parent_id == dest.parent_id)
  end

  def render_central(mode =nil)
    @layout[:centre] = mode if mode
    respond_to do |format|
      format.html { render :action=>'show'}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'centre',  :partial => @layout[:centre] ,:locals=>{:folder=>@project_folder}
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
     @project_folder = ProjectFolder.find(params[:folder_id] || params[:id]) ||  current_project.home
  end  

end
