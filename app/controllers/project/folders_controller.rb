require 'htmldoc'

class Project::FoldersController < ApplicationController
 
  use_authorization :folders,
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
    respond_to do |format|
      format.html {render :action => 'show'}
      format.ext {render :action => 'show',:layout => false}
      format.pdf {render_pdf :action => 'show',:layout => false}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'tab-folder',  :partial => @layout[:centre] ,:locals=>{:folder=>@project_folder}
           page.replace_html 'messages',:partial => 'shared/messages', :locals => { :objects => ['project','project_folder','project_element','project_content']}
        end
      }
    end 
  end

  def folder
    set_folder
    respond_to do |format|
      format.html {render :partial => 'show',:locals=>{:folder=>@project_folder}}
      format.ext {render :partial => 'show',:locals=>{:folder=>@project_folder}}
      format.pdf {render_pdf :partial => 'show',:locals=>{:folder=>@project_folder}}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'tab-folder',  :partial => @layout[:centre] ,:locals=>{:folder=>@project_folder}
           page.replace_html 'messages',:partial => 'shared/messages', :locals => { :objects => ['project','project_folder','project_element','project_content']}
        end
      }
    end 
  end

##
# Display the current clipboard 
# 
  def document
    set_folder
    respond_to do |format|
      format.html {render :partial => 'document',:locals=>{:folder=>@project_folder}}
      format.ext {render :partial => 'document',:locals=>{:folder=>@project_folder}}
      format.pdf {render_pdf :partial => 'document',:locals=>{:folder=>@project_folder}}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'tab-document',  :partial => 'document' ,:locals=>{:folder=>@project_folder}
           page.replace_html 'messages',:partial => 'shared/messages', :locals => { :objects => ['project','project_folder','project_element','project_content']}
        end
      }
    end 
  end    

##
# Display the current clipboard 
# 
  def layout
    set_folder
    respond_to do |format|
      format.html {render :partial => 'layout',:locals=>{:folder=>@project_folder}}
      format.ext {render :partial => 'layout',:locals=>{:folder=>@project_folder}}
      format.pdf {render_pdf :partial => 'layout',:locals=>{:folder=>@project_folder}}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'tab-outline',  :partial => 'layout' ,:locals=>{:folder=>@project_folder}
           page.replace_html 'messages',:partial => 'shared/messages', :locals => { :objects => ['project','project_folder','project_element','project_content']}
        end
      }
    end 
  end
##
# Display the current clipboard 
# 
  def blog
    set_folder
    respond_to do |format|
      format.html {render :partial => 'blog',:locals=>{:folder=>@project_folder}}
      format.ext {render :partial => 'blog',:locals=>{:folder=>@project_folder}}
      format.pdf {render_pdf :partial => 'blog',:locals=>{:folder=>@project_folder}}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'tab-blog',  :partial => 'blog' ,:locals=>{:folder=>@project_folder}
           page.replace_html 'messages',:partial => 'shared/messages', :locals => { :objects => ['project','project_folder','project_element','project_content']}
        end
      }
    end 
  end  
###
##
# Display the current clipboard 
# 
  def print
    set_folder
    respond_to do |format|
      format.html { render :action => 'print', :layout => "layouts/printout.rhtml"}
      format.pdf {render_pdf("#{@project_folder.name}.pdf",{:action => 'print', :layout => "layouts/printout.rhtml"})}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |
           page.replace_html 'create',  :partial => 'print' ,:locals=>{:folder=>@project_folder}
         end
      }
    end  
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
    @source = ProjectElement.find(params[:id]) 
    set_folder @source.parent_id
    @clipboard = session[:clipboard] || Clipboard.new
    @clipboard.add(@source)
    session[:clipboard] = @clipboard
    
    respond_to do |format|
      format.html {render :show => 'show'}
      format.xml  { render :xml => @clipboard.to_xml}
      format.js  { render :update do | page |
           page.replace_html 'panel-clipboard',  :partial => 'clipboard'
           page.replace_html 'messages',:partial => 'shared/messages', :locals => { :objects => ['project','project_folder','project_element','project_content']}
        end }
    end  
  end  
  
  def clear_clipboard
    set_folder
    @clipboard =Clipboard.new
    session[:clipboard] = @clipboard
    respond_to do |format|
      format.html {render :show => 'show'}
      format.xml  { render :xml => @clipboard.to_xml}
      format.js  { render :update do | page |
           page.replace_html 'panel-clipboard',  :partial => 'clipboard'
           page.replace_html 'messages',:partial => 'shared/messages', :locals => { :objects => ['project','project_folder','project_element','project_content']}
        end }
    end  
  end

##
# Display the current clipboard 
# 
  def finder
    set_folder
    @hits = []
    @clipboard = session[:clipboard] 
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
    respond_to do |format|
      format.html { render :action => 'new'}
      format.js  { render :update do | page |
           page.replace_html 'centre',  :partial => 'new' ,:locals=>{:folder=>@parent}
         end
      }
    end  
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
      render :action => 'show'
    else
      flash[:error] = 'ProjectFolder creation failed.'
      render :action => 'show'
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


#
#  AJAX called method to reorder the elements in folder before a set element
#
#   :id = source
#   :before = element to place element before
#
  def reorder_element
     @source =  current(ProjectElement, params[:id] ) 
     @project_element =  current(ProjectElement, params[:before] ) 
     set_folder(@source.parent_id)
     if @source.parent_id ==  @project_element.parent_id
        @source.reorder_before( @project_element )       
        @project_folder.reload
     end
     
    respond_to do |format|
      format.html { render :action => 'show'}
      format.json { render :partial => "reorder"};
    end  
  end
#
#  AJAX called method to add a element to a folder before a set element
#
#   :id = source
#   :before = element to place element before
#
  def add_element   
    @source =  current(ProjectElement, params[:id] ) 
    if  params[:before]
      @project_element =  current(ProjectElement, params[:before] ) 
      set_folder(@project_element.parent_id)
    else
      set_folder(params[:folder])
    end
    if @source.id != @project_folder.id and @source.parent_id != @project_folder.id
       @new_element = @project_folder.copy(@source)
       @new_element.reorder_before( @project_element ) if @project_element
       flash[:info] = "add reference to #{@source.name} to #{@project_folder.name}"
    else  
       flash[:warning] = "can not add to #{@source.name} to #{@project_folder.name}"
    end
    @project_folder.reload
    respond_to do |format|
      format.html { render :action => 'show'}
      format.json { render :partial => "reorder"};
    end  
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
    @choices = ProjectAsset.find(:all,
                                :conditions=>['project_id=? and name like ? ', current_project.id, "#{@value}%"],
                                :order=>"abs(#{params[:id]} - parent_id) asc,parent_id,name",
                                :limit=>10)
    render :partial=>'choices',:layout=>false
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
    render :inline => ""                        
  end    
  
  
protected

  def allowed_move(source,dest)
     return !(source.id == dest.id or source.id == dest.parent_id or  source.parent_id == dest.id  or source.parent_id == dest.parent_id)
  end

##
# Simple helpers to get the current folder from the session or params 
#  
  def set_folder(id = nil)
     id ||= params[:folder_id] || params[:id]
     ProjectFolder.current = @project_folder = current_user.folder(id) ||  current_project.home
     @layout = {}
     @layout[:right] = params[:right] || 'right_finder'
     @layout[:centre] = params[:centre] || 'show'     
     @clipboard = session[:clipboard] 
     @clipboard ||= Clipboard.new
     return @project_folder
  end  
  
end
