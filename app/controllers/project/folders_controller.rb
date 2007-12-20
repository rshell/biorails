require 'htmldoc'

class Project::FoldersController < ApplicationController
 
  use_authorization :folders,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights =>  :current_project  

  def index
    redirect_to :action => 'show' ,:id=>current_project.home
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
    @project_folder = set_folder(params[:id])
    respond_to do |format|
      format.html {render :action => 'show'}
      format.pdf {render_pdf :action => 'show',:layout => false}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
      format.js  { render :update do | page |  
          page.work_panel   :partial => 'shared/clipboard'
		  page.main_panel  :partial => 'show'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
       end 
      }    
	end 
  end

  def document
    @project_folder = set_folder(params[:id])
    respond_to do |format|
      format.html {render :partial => 'document', :locals=>{:folder=>@project_folder} }
      format.pdf {render_pdf("#{@project_folder.name}.pdf",{:action => 'print', :layout => "layouts/printout.rhtml"})}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
	end 
  end
    
###
##
# Display the current folder for printout 
# 
  def print
    @project_folder = set_folder(params[:id])
    respond_to do |format|
      format.html { render :action => 'print', :layout => "layouts/printout.rhtml"}
      format.pdf {render_pdf("#{@project_folder.name}.pdf",{:action => 'print', :layout => "layouts/printout.rhtml"})}
      format.xml  { render :xml => @project_folder.to_xml(:include=>[:content,:asset,:reference])}
    end  
  end
###
##
# Sign the folder by creating a pdf of the cntents and displaying a form for signature  
  def sign
    folder = current_user.folder(params[:folder_id]||params[:id])
    @signable_document="<h2>"<< folder.name << "</h2>"
     for item in folder.children     
       if item.asset? and item.asset.image? 
         @signable_document << "<h4>Figure: " << item.name << "</h4>"
         @signable_document << "<p><img src='"  << item.asset.public_filename << "' alt='" << item.name << "'/></p>"
         @signable_document << "<i>" << item.description << "</i>"
       elsif item.textual? 
         @signable_document << "<h2>" << item.content.title << "</h2>"
         @signable_document << "<p>" << item.to_html << "</p>"
       else 
         @signable_document << "<h2>" << item.title << "</h2>"
         @signable_document << item.to_html
       end
       #use has_file lib to save pdf to temp directory
    folder.signed_pdf=render_to_pdf @signable_document
    end
    respond_to do |format|
      format.html { render :action=>'print'}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:project])}
      format.js  { render :update do | page |  
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'show_signable_document',:locals=>{:current_user=>current_user,:folder=>folder, :document=>@signable_document}
       end
     }
    end
  end
##
#
#  
#      
  def grid
    @elements =  get_folder_page
    render :partial =>  'grid', :layout=>false 	
  end
###
# List of elements in the route home folder
# 
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id]
#  * @project based on folder
# 
  def new
    @parent =  set_folder(params[:id]||params[:folder_id])
    @project_folder = ProjectFolder.new(:name=> Identifier.next_user_ref, 
                                        :parent_id=>@parent.id,
                                        :project_id=>@parent.project_id)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @project_folder.to_xml }
      format.csv  { render :text => @project_folder.to_csv }
      format.json { render :json =>  @project_folder.to_json }  
      format.js  { render :update do | page |  
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial =>'new'
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
    @project_folder = set_folder(params[:id])
    @child_folder = @project_folder.folder(params[:project_folder][:name])
    if @child_folder.save
      flash[:notice] = 'ProjectFolder was successfully created.'
	  respond_to do |format|
		  format.html { redirect_to  :action => 'show',:id => @project_folder    }
		  format.xml  { head :created, :location => projects_url(@project_folder   ) }
		  format.js  { render :update do | page |  
			  page.actions_panel  :partial => 'actions'
			  page.help_panel     :partial => 'help'
			  page.status_panel   :partial => 'status'
			  page.main_panel     :partial => 'show'
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
          format.js  { render :update do | page |  
			  page.actions_panel  :partial => 'actions'
			  page.help_panel     :partial => 'help'
			  page.status_panel   :partial => 'status'
			  page.main_panel     :partial => 'new'
			end
		   }
		end 
    end
  end
##
# Edit the current folder details
#
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id] 
# 
  def edit
    @project_folder = set_folder(params[:id])
    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml {render :xml =>  @project_folder.to_xml}
      format.json  { render :text => @project_folder.to_json }
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'edit'
        end
      }
    end
  end
##
# Update the current folder details
#
#  * @project_folder based on params[:folder_id] || params[:id] || session[:folder_id] then updated from params[:project_folder]
#
  def update
    @project_folder = set_folder(params[:id])
    if @project_folder.update_attributes(params[:project_folder])
      flash[:notice] = 'ProjectFolder was successfully updated.'
	  respond_to do |format|
		  format.html { redirect_to  :action => 'show',:id => @project_folder    }
		  format.xml  { head :created, :location => folders_url(@project_folder) }
		  format.js  { render :update do | page |  
			  page.actions_panel  :partial => 'actions'
			  page.help_panel     :partial => 'help'
			  page.status_panel   :partial => 'status'
			  page.main_panel     :partial => 'show'
			end
		   }
		end 
    else
	  respond_to do |format|
		  format.html { redirect_to  :action => 'edit',:id => @project_folder    }
		  format.xml  { head :created, :location => folders_url(@project_folder   ) }
		  format.js  { render :update do | page |  
			  page.actions_panel  :partial => 'actions'
			  page.help_panel     :partial => 'help'
			  page.status_panel   :partial => 'status'
			  page.main_panel     :partial => 'edit'
			end
		   }
		end 
    end
  end
##
# Destroy the the  folder
#
  def destroy
    logger.info "destroy"
    element  = ProjectElement.find(params[:id]) 
	@project_folder = element.parent
    element.destroy
    respond_to do |format|
      format.html { redirect_to :action => 'show', :id=>element.parent_id }
      format.xml  { head :ok }
      format.js  { render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'show'
          end
      }
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
        format.js { render :update do | page |  
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
      format.js { render :update do | page |  
              page.status_panel   :inline => flash[:warning] if flash[:warning]
              page.refresh
            end
        }
    end  
  end

  
##
# Autocomplete for a data element lookup return a list of matching records.
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

	@list = {:element_id=>params[:id],
			 :matches=>@value,
			 :total=>100 ,
			 :items =>@choices.collect{|i|{:id=>i.id,:name=>i.name,:path=>i.path, :icon=>i.icon( {:images=>true} )}} }
     render :text => @list.to_json
  end  
  
protected
  def render_to_pdf html
     pdf = PDF::HTMLDoc.new
      pdf.set_option :webpage, true
      pdf.set_option :toc, true
      pdf.set_option :links, false
      pdf << html
    end
    
  
    def get_folder_page
	  
    @project_folder = ProjectFolder.find(params[:id]) 
    labels =['parent_id = ?']
    values =[params[:id]]

    start = (params[:start] || 1).to_i      
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
         if field && data
            case data['comparison']
            when 'gt'
              labels << "#{field} > ? "
              values << data['value']
            when 'lt'
              labels << "#{field} < ? "
              values << data['value']
            when 'list' 
              labels << "#{field} in (#{data['value']}) "
            when 'like'
                labels << "#{field} like ? "
                values << data['value']+"%"
            when 'eq'
                labels << "#{field} = ? "
                values << data['value']
            else  
                labels << "#{field} like ? "
                values << data['value']+"%"
            end
        end
      end
	end
    conditions = [labels.join(" and ")] +values
    return ProjectElement.find(:all, 
           :limit=>size,
           :conditions=> conditions ,
           :offset=>start, 
           :order=>sort_col+' '+sort_dir)
      
  end


  def allowed_move(source,dest)
     return !(source.id == dest.id or source.id == dest.parent_id or  source.parent_id == dest.id  or source.parent_id == dest.parent_id)
  end

end
