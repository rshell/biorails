##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class Project::FoldersController < ApplicationController
 
  use_authorization :project,
    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
    :rights =>  :current_project  

  def index
    redirect_to :action => 'show' ,:id=>current_project.home
  end

  before_filter :setup_folder,
    :only => [ :show, :document,:print,:new,:create,:edit, :update]

  # ## List of elements in the route home folder
  # 
  #  * @project based on current context params[:project_id] || params[:id] || session[:project_id]
  #  * @project_folder based on home folder for project
  # 
  def list
    redirect_to :action => 'show' ,:id=>current_project.home
  end
  # ## List of elements in for a folder
  # 
  #  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
  #  * @project based on folder
  # 
  def show
    respond_to do |format|
      format.html {render :action => 'show'}
      # #format.pdf {render_pdf :action => 'show',:layout => false}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { 
        render :update do | page |  
          page.work_panel   :partial => 'shared/clipboard'
          page.main_panel   :partial => 'show_folder'
          page.help_panel   :partial => 'help'
          page.status_panel :partial => 'status'
        end 
      }    
    end 
  end
  
  def document
    respond_to do |format|
      format.html {render :action => 'document'}
      format.ext  {render :partial => 'document', :locals=>{:folder=>@project_folder} }
      format.pdf  {render_folder_pdf(@project_folder)}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { 
        render :update do | page |  
          page.work_panel   :partial => 'shared/clipboard'
          page.main_panel   :partial => 'show_document'
          page.help_panel   :partial => 'help'
          page.status_panel :partial => 'status'
        end 
      }    
    end 
  end
    
  # ### ## Display the current folder for printout
  # 
  def print
   #self.default_image_size = :normal can resize images if needed 
    respond_to do |format|
      format.html { render :action => 'print', :layout => "layouts/printout.rhtml"}
      format.pdf {render_folder_pdf(@project_folder)}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
    end  
  end
  
    
  def grid
    @elements =  get_folder_page
    render :partial =>  'grid', :layout=>false 	
  end
  # ### List of elements in the route home folder
  # 
  #  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
  #  * @project based on folder
  # 
  def new
    @parent =  @project_folder
    @project_folder = ProjectFolder.new(:name=> Identifier.next_user_ref, 
      :parent_id=>@parent.id,
      :project_id=>@parent.project_id)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @project_folder.to_xml }
      format.csv  { render :text => @project_folder.to_csv }
      format.json { render :json =>  @project_folder.to_json }  
      format.js  { 
        render :update do | page |  
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial =>'new'
        end 
      }
    end  
  end
  # ## Create a new child folder
  # 
  #  * @parent based on params[:folder_id] || params[:id] || session[:folder_id]
  #  * @project_folder created from module forparams[:project_folder]
  # 
  def create
    @child_folder = @project_folder.folder(params[:project_folder][:name])
    if @child_folder.save
      @project_folder.reload
      flash[:notice] = 'ProjectFolder was successfully created.'
      respond_to do |format|
        format.html { redirect_to  :action => 'show',:id => @project_folder    }
        format.xml  { head :created, :location => project_url(:action=>'show',:id =>@project_folder   ) }
        format.js  { 
          render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'show_folder'
          end
        }
      end 
    else
      flash[:error] = 'ProjectFolder creation failed.'
      @parent = @project_folder 
      @project_folder = @child_folder
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @child_folder.errors.to_xml }			  
        format.js  { 
          render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'new'
          end
        }
      end 
    end
  end
  # ## Edit the current folder details
  # 
  #  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
  # 
  def edit
    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml {render :xml =>  @project_folder.to_xml}
      format.json  { render :text => @project_folder.to_json }
      format.js  { 
        render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'edit'
        end
      }
    end
  end
  # ## Update the current folder details
  # 
  #  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id] then updated from params[:project_folder]
  # 
  def update
    if @project_folder.update_attributes(params[:project_folder])
      flash[:notice] = 'ProjectFolder was successfully updated.'
      respond_to do |format|
        format.html { redirect_to  :action => 'show',:id => @project_folder    }
        format.xml  { head :created, :location => folders_url(@project_folder) }
        format.js  { 
          render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'show_folder'
          end
        }
      end 
    else
      respond_to do |format|
        format.html { redirect_to  :action => 'edit',:id => @project_folder    }
        format.xml  { head :created, :location => folders_url(@project_folder   ) }
        format.js  { 
          render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'edit'
          end
        }
      end 
    end
  end
  # ## Destroy the the  folder
  # 
  def destroy
    logger.info "destroy"
    element  = ProjectElement.find(params[:id]) 
    @project_folder = element.parent
    element.destroy
    respond_to do |format|
      format.html { redirect_to :action => 'show', :id=>element.parent_id }
      format.xml  { head :ok }
    end
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
    @project_folder = set_folder(@source.parent_id)
    if @source.parent_id ==  @project_element.parent_id
      @source.reorder_before( @project_element )       
      @project_folder.reload
    end     
    respond_to do |format|
      format.html { render :action => 'show'}
      format.json { render :partial => "reorder"};
      format.js { 
        render :update do | page |  
          page.status_panel :inline =>" Source [#{ @source.name}] moved before [#{@project_element.name}]"
        end
      }
    end  
  end
  # 
  #  AJAX called method to add a element to a folder before a set element
  # 
  #   :id = source
  #   :before = element to place element before
  # 
  def add_element   
    @project_folder = set_folder(params[:folder_id])  if params[:folder_id]
    @source =  current(ProjectElement, params[:id] ) 
    
    if  params[:before]
      @project_element =  current(ProjectElement, params[:before] ) 
      @project_folder = set_folder(@project_element.parent_id)
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
      format.json { render :partial => "reorder"}
      format.js { 
        render :update do | page |  
          page.status_panel :inline => flash[:warning] if flash[:warning]
          page.main_panel   :partial => 'show_folder'
        end
      }
    end  
  end

  
  # ## Autocomplete for a data element lookup return a list of matching records.
  # This is simple helper for lots of forms which want drop down lists of items
  # controller from the central catalog.
  # 
  #  * url is in the form /data_element/choices/n with value=xxxx parameter
  # 
  def select
    @value   = params[:query] || ""
    @choices = ProjectAsset.find(:all,
      :conditions=>['project_id=? and name like ? ', current_project.id, "#{@value}%"],
      :order=>"abs(#{params[:id]} - parent_id) asc,left_limit,name",
      :limit=>10)
    @list = {:element_id=>params[:id],:matches=>@value,:total=>100 ,:items =>@choices.collect{|i|{:id=>i.id,:name=>i.name,:path=>i.path, :icon=>i.icon( {:images=>true} )}} }
    render :text => @list.to_json
  end  
  
  protected
    
  def setup_folder
    @project_folder = current_user.folder(params[:id]||params[:folder_id]) 
    if @project_folder 
      set_project(@project_folder.project)
      ProjectFolder.current = @project_folder
      return @project_folder
    else
      return show_access_denied
    end
  end
  
  # ## Render a folder as PDF for output - this method includes all documents
  # inline and so avoids problems with relative paths
  # 
  def render_folder_pdf(folder)
    filename=File.join('/tmp',"#{underscore(folder.name)}.pdf")
    pdf = folder.make_pdf(filename) 
    pdf.errors.map{ |key, error| logger.warn " PDF '#{filename} create problem #{key}: #{error}"} 
    send_file(filename ,  :type => 'application/pdf', :disposition=>'inline')
  end
  
  def get_folder_page
    @project_folder = ProjectFolder.find(params[:id]) 
    labels =['parent_id = ?']
    values =[params[:id]]

    start = (params[:start] || 0).to_i      
    size = (params[:limit] || 25).to_i 
    
    sort_col = params[:sort] if params[:sort] and params[:sort].size > 1
    sort_col ||= 'id' 
    sort_dir = ( params[:dir] || 'ASC' )
    
    where = params[:where] || {}

    page = ((start/size).to_i)+1

    if where.size >0
      where.values.each do |item| 
        field = item[:field]
        data = item[:data]
        value = data[:value]
        if field && data
          case data[:comparison]
          when 'gt'
            labels << "#{field} > ? "
            values << value
          when 'lt'
            labels << "#{field} < ? "
            values << value
          when 'list' 
            labels << "#{field} in (#{value}) "
          when 'like'
            labels << "#{field} like ? "
            values << value+"%"
          when 'eq'
            labels << "#{field} = ? "
            values << value
          else  
            labels << "#{field} like ? "
            values << value+"%"
          end
        end
      end
    end
    conditions = [labels.join(" and ")] +values
    elements =  ProjectElement.find(:all, 
      :limit=>size,
      :conditions=> conditions ,
      :offset=>start, 
      :order=>sort_col+' '+sort_dir)     
     elements.sort{|a,b|a.left_limit <=> b.left_limit}.each_with_index{|e,i| e.position=i+start+1} 
     return elements
  end


end
