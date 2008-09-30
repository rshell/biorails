class Admin::StatesController < ApplicationController

  use_authorization :catalogue, 
              :actions => [:list,:show,:new,:create,:edit,:update,:destroy], 
              :rights => :current_user
 
  before_filter :find_state ,  :only => [ :show, :edit, :update,:destroy]

  before_filter :find_states , :only => [ :grid,:workflow,:list,:index]
  
  
  def index
    render :action => "list"
  end

  def list
    render :action => "list"
  end

  def workflow
    State.set_flow(params[:state],@label)
    redirect_to :action => "list",:flow=>@label
  end
  
    
  def show
  end
  #
  # Display form for new state 
  #
  def new
    @state = State.new
  end
  #
  # Create a new state 
  #
  def create
    @state = State.new(params[:state])
    if @state.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @state.update_attributes(params[:state])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end
  
  def move
    case params[:position]
    when 'highest'
      @state.move_to_top
    when 'higher'
      @state.move_higher
    when 'lower'
      @state.move_lower
    when 'lowest'
      @state.move_to_bottom
    end if params[:position]
    redirect_to :action => 'list'
  end

  def destroy
    @state.destroy
    redirect_to :action => 'list'
  rescue
    flash[:error] = "Unable to delete state"
    redirect_to :action => 'list'
  end  	

  protected  

  def find_state
    @state = State.find(params[:id]||:first)
  end
#
# Get the current page of objects
# 
  def find_states
    @labels = State.labels
    @label = params[:flow] ||'default'
    @states = State.find(:all,:order=>'level_no asc ,id asc')
  end

end
