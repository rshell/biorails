class Admin::StateFlowsController < ApplicationController

  use_authorization :catalogue,
              :admin => [:new,:create,:destroy,:edit,:index,:list,:show,:update,:workflow]
 
  before_filter :find_workflow ,  :only => [ :show, :edit, :update,:destroy]

  

  def index
    list
  end

  def list
    @report = Biorails::SystemReportLibrary.state_flow_list
    respond_to do | format |
      format.html { render :action => 'list' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.pdf  { render_pdf "state_flows.pdf",:action => 'list',:layout=>false }
      format.json { render :json => @report.data.to_json }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end


  def show
  end

  #
  # Display form for new state
  #
  def new
    @state_flow = StateFlow.new
  end
  #
  # Create a new state
  #
  def create
    @state_flow = StateFlow.new(params[:state_flow])
    if @state_flow.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @state_flow.update_attributes(params[:state_flow]) and not params[:state].blank?
       @state_flow.set_flow(params[:state])
    else
      flash[:warning] ="Failed to update workflow"
    end
    redirect_to :action => "show",:id=>@state_flow
  end



  def destroy
    @state_flow.destroy
    redirect_to :action => 'list'
  rescue
    flash[:error] = "Unable to delete state flow"
    redirect_to :action => 'list'
  end

  protected
#
# Get the current page of objects
#
  def find_workflow
    @state_flow  =StateFlow.find(params[:id]) unless  params[:id].blank?
    @states = State.find(:all,:order=>'level_no asc ,id asc')
  end

end
