class AccessControlListController < ApplicationController
  
  use_authorization :project,
                    :actions => [:show,:edit,:update,:remove,:add_user,:add_team],
                    :rights => :current_user

  before_filter :get_element ,  :only => [ :show,:edit]
  before_filter :get_acl ,  :only => [ :add_user,:add_team,:update]
  before_filter :get_ace ,  :only => [ :remove]
  
#
# Edit the Access control list
# :id project element id
#
  def show
    respond_to do |format|
      format.html { render :action => 'show' }
      format.ext { render :partial => 'show' }
      format.pdf  { render_pdf :action => 'show',:layout=>false }
      format.xml  { render :xml => @acl.to_xml }
      format.js  { 
        render :update do | page |  
          page.main_panel   :partial => 'show'
          page.help_panel   :partial => 'help'
        end 
      }    
    end
  end
#
# Edit the Access control list
# :id project element id
#
  def edit
    @acl = @acl.copy unless @acl.changable?
    respond_to do |format|
      format.html { render :action=>:edit}
      format.ext { render :partial=>:edit}
      format.xml  { render :xml => @acl.to_xml }
    end
  end

  def edit
    @acl = @acl.copy unless @acl.changable?
    respond_to do |format|
      format.html { render :action=>:edit}
      format.xml  { render :xml => @acl.to_xml }
    end
  end

  def team
    @acl = @acl.copy unless @acl.changable?
    respond_to do |format|
      format.html { render :action=>:edit}
      format.xml  { render :xml => @acl.to_xml }
    end
  end
  
  #
  # Update Access control List on a ProjectElement
  # :id = AccessControlElement.id
  # :project_element_id = ProjectElement.id
  # :children = true/false
  #
  def update
    ok = false
    if params[:commit]== l(:button_save)   
              
        logger.info flash[:info] ="updated access control list #{@project_element.access_control_list_id} => #{@acl.id}"
        @acl = AccessControlList.find(params[:access_control_list_id])
        ok = @project_element.update_acl(@acl,params[:children])
    else
         logger.info flash[:info] ="Canceled changes to access "
         ok =@acl.destroy unless @acl.used?
    end
    if ok
      redirect_to folder_url(:action=>'show',:id=>@project_element.id)
    else
      render :action=>:edit
    end
  end
  #
  # Remove Access control element from the list
  # :id = AccessControlElement.id
  #
  def remove
    @ace.destroy 
    respond_to do |format|
      format.html { redirect_to :action=>:edit,:id=>@acl.id}
      format.ext  { render :partial=>:edit}
      format.js  { 
        render :update do | page |  
          page.main_panel   :partial => 'edit'
          page.help_panel   :partial => 'help'
        end 
      }
    end    
  end
#
# Add a user to the access control list
# :id  the acess control list
# :user_id
# :role_id
#
  def add_user
    @acl.grant(params[:user_id],params[:role_id],'User')
    respond_to do |format|
      format.html { redirect_to :action=>:edit,:id=>@acl.id}
      format.ext  { render :partial=>:edit}
      format.js  { 
        render :update do | page |  
          page.main_panel   :partial => 'edit'
          page.help_panel   :partial => 'help'
        end 
      }
    end    
  end
#
# Add a team to the access control list
# :id  the acess control list
# :team_id
# :role_id
#
  def add_team
    @acl.grant(params[:team_id],params[:role_id],'Team')
    respond_to do |format|
      format.html { redirect_to :action=>:edit,:id=>@acl.id}
      format.ext  { render :partial=>:edit }
      format.js  { 
        render :update do | page |  
          page.main_panel   :partial => 'edit'
          page.help_panel   :partial => 'help'
        end 
      }
    end    
  end

  protected
    def get_acl
      @acl = AccessControlList.find(params[:access_control_list_id])      
      @project_folder = @project_element = ProjectElement.find(params[:project_element_id])
    end
    
    def get_ace
      @ace = AccessControlElement.find(params[:access_control_element_id])
      @project_folder =@project_element = ProjectElement.find(params[:project_element_id])
      @acl = @ace.access_control_list 
    end

    def  get_element
      @project_folder = @project_element = ProjectElement.find(params[:id],
                                               :include=>[:access_control_list])      
      @acl = @project_element.access_control_list
      @acl ||= AccessControlList.create
    end
end
