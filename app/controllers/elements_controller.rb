##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class ElementsController < ApplicationController

  use_authorization :project,
    :use => [:new,:create,:edit,:show,:state,:tree,:update]

  before_filter :load_folder,
    :only => [ :new,:create]

  before_filter :load_element,
    :only => [ :show, :tree,:edit,:update]

  ##
  # Display a article
  #
  def show
    respond_to do |format|
      format.html { render :action=>'show'}
      format.ext { render :partial =>'show',:layout=>false}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset,:reference])}
      format.js  {  render :action=>'show', :layout=>false
      }
    end  
  end

  # 
  # Create a Tree data model
  # 
  def tree    
    respond_to do | format |
      format.html { render :inline => "<%=project_tree(@project_element)%>"}
      format.json { render :inline => "<%=project_tree(@project_element)%>"}
    end
  end
  
  ##
  # Display the current clipboard
  #
  def new
    return show_access_denied unless @project_folder.changeable?
    @project_element = @element_type.new_element(@project_folder,{})
    logger.info "new element "+ @project_element.to_xml
    respond_to do |format|
      format.html { render :action=>'new'}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:project])}
      format.js  { render :update do | page |
          page.status_panel :partial=> 'messages'
          page.main_panel  :partial=>'new'
        end
      }
    end  
  end
  ##
  # Save a article
  #
  def create
    return show_access_denied unless @project_folder.changeable?
    ProjectElement.transaction do
      @project_element = @project_folder.add_element(@element_type,params[:project_element])   
      unless @project_element.save
        # flash[:error] = "Validation failed  #{@project_element.content.errors.full_messages.to_sentence} #{@project_element.errors.full_messages.to_sentence}"
        respond_to do |format|
          format.html { render :action=>'new'}
          format.xml  { render :xml => @project_element.to_xml(:include=>[:project])}
          format.js  { render :update do | page |
              page.status_panel :partial=> 'messages'
              page.main_panel   :partial=> 'new'
            end
          }
        end
      else
        respond_to do |format|
          format.html { redirect_to folder_url(:action => 'show', :id => @project_folder) }
          format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset])}
          format.js  { render :update do | page |
              page.status_panel :partial=> 'messages'
              page.main_panel   :partial=> 'show'
            end
          }
        end
      end
    end
  end

  def state
    begin
    message = ""
    @project_element = ProjectElement.load(params[:id] )
    @new_state = State.find(params[:state_id])
    if @new_state
      @project_element.set_state(@new_state,true)
      @project_element.reload
    end
    rescue Exception =>ex
     message =  ex.message
    end
    case params[:display]
    when 'combo'
      render :inline=> "<%=states_combo(@project_element)%> #{message}"
    else
      render :text=>  "#{@project_element.state_id} #{message}"
    end
  end
  ##
  # Edit a article
  #
  def edit
    return show_access_denied unless @project_folder.changeable?
    respond_to do |format|
      format.html { render :action=>'edit'}
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content])}
      format.js  { render :update do | page |
          page.status_panel :partial=> 'messages'
          page.main_panel   :partial=> 'edit'
        end
      }
    end  
  end

  ##
  # Save a article
  #
  def update
    return show_access_denied unless @project_folder.changeable?
    ProjectElement.transaction do
      @project_element.fill(params[:project_element])
      unless @project_element.save
        logger.error " Errors #{@project_element.errors.full_messages.to_sentence}"
        flash[:error] = "Failed to save element <br/> #{@project_element.errors.full_messages.to_sentence}"
      end
    end
    respond_to do |format|
      format.html { redirect_to params[:back] || folder_url(:action => 'show', :id => @project_folder) }
      format.xml  { render :xml => @project_element.to_xml(:include=>[:content,:asset])}
      format.js  { render :update do | page |
          page.status_panel :partial=> 'messages'
          page.main_panel   :partial=> 'show'
        end
      }
    end
  end

  protected
  ##
  # Load the contents
  #
  def load_element
    @project_element = ProjectElement.load(params[:id] )
    set_element(@project_element)
    @element_type    = @project_element.element_type
    @project_folder  = @project_element.parent || @project_element
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end
  ##
  # Simple helpers to get the current folder from the session or params
  #
  def load_folder
    @project_folder = ProjectFolder.load(params[:folder_id]||params[:id])
    @element_type = ElementType.find_by_name(params[:style]||'html')
    return show_access_denied unless  @project_folder.changeable?

  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end  
                    

end
