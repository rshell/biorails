class Project::ProjectsController < ApplicationController

  use_authorization :project,
                    :actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
                    :rights =>  :current_project  

##
# Generate a index dashboard for the project 
#   
  def index
    @users = User.find(:all)
    @project = Project.find(params[:id])
    @events, @todays_events, @yesterdays_events = [], [], []
    today, yesterday = Time.now.utc.to_date, 1.day.ago.utc.to_date
    @articles = @project.unapproved_comments.count :all, :group => :article, :order => '1 desc'
    @project.events.find(:all, :order => 'events.created_at DESC', :include => [:article, :user], :limit => 50).each do |event|
      event_date = event.created_at.to_date
      if event_date >= today
        @todays_events
      elsif event_date == yesterday
        @yesterdays_events
      else
        @events
      end << event
    end
  end

##
# Generate a index dashboard for the project 
#  
  def show
    @project =  current(Project,params[:id])
    set_project(@project)    
  end

  def tree
    @project =  current(Project,params[:id])
    set_project(@project)   
    render :action=>'tree' ,:layout => false
  end

  def new
    @project = Project.new
    @user = current_user
  end

  def create
    @user = current_user    
    @project = current_user.create_project(params[:project][:name])
    @project.summary = params[:project][:summary]
    if @project.save
      flash[:notice] = 'Sample was successfully created.'
      set_project(@project)
      redirect_to  :action => 'show',:id => @project      
    else
      render :action => 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:sample])
      flash[:notice] = 'Sample was successfully updated.'
      redirect_to :action => 'show', :id => @project
    else
      render :action => 'edit'
    end
  end
  

##
# List of most recent experiments
# 
  def experiments
     @project = current(Project,params[:id])
     sort_init 'name'
     sort_update
     @item_pages, @items = paginate :experiments,  :order_by => sort_clause, :per_page => 20
     render :action => "experiments", :layout => false if request.xhr?
  end
##
# List of the Reports Defined for use with the project
# 
  def reports
     @project = current(Project,params[:id])
     sort_init 'name'
     sort_update
     @item_pages, @items = paginate :reports, :order_by => sort_clause, :per_page => 20
     render :action => "reports", :layout => false if request.xhr?
  end
##
# List of the membership of the project
# 
  def members
     @project = current(Project,params[:id])
     @membership = Membership.new(:project_id=>@project)
  end
##
# add a  
  def add_member
  
  end
##
# Show a overview calendar for the project this should list the experiments, documents etc linked into the project
# 
  def calendar
     @project = current(Project,params[:id])
    if params[:year] and params[:year].to_i > 1900
      @year = params[:year].to_i
      if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
        @month = params[:month].to_i
      end    
    end
    @year ||= Date.today.year
    @month ||= Date.today.month
    
    @date_from = Date.civil(@year, @month, 1)
    @date_to = (@date_from >> 1)-1
    # start on monday
    @date_from = @date_from - (@date_from.cwday-1)
    # finish on sunday
    @date_to = @date_to + (7-@date_to.cwday)  
      
    @tasks = Task.find(:all, :order => "started_at, ended_at", :include => [:experiment], 
                         :conditions => ["(((started_at>=? and started_at<=?) or (ended_at>=? and ended_at<=?) or (started_at<? and ended_at>?)) and started_at is not null and ended_at is not null)", @date_from, @date_to, @date_from, @date_to, @date_from, @date_to])
    
    render :layout => false if request.xhr?
  end  

##
# Display of Gantt chart of task in  the project
# This will need to show studies,experiments and tasks in order
#   
  def gantt
     @project = current(Project,params[:id])
    if params[:year] and params[:year].to_i >0
      @year_from = params[:year].to_i
      if params[:month] and params[:month].to_i >=1 and params[:month].to_i <= 12
        @month_from = params[:month].to_i
      else
        @month_from = 1
      end
    else
      @month_from ||= (Date.today << 1).month
      @year_from ||= (Date.today << 1).year
    end
    
    @zoom = (params[:zoom].to_i > 0 and params[:zoom].to_i < 5) ? params[:zoom].to_i : 2
    @months = (params[:months].to_i > 0 and params[:months].to_i < 25) ? params[:months].to_i : 6
    
    @date_from = Date.civil(@year_from, @month_from, 1)
    @date_to = (@date_from >> @months) - 1

    @tasks = Task.find(:all, :order => "started_at, ended_at", :include => [:experiment], 
                         :conditions => ["(((started_at>=? and started_at<=?) or (ended_at>=? and ended_at<=?) or (started_at<? and ended_at>?)) and started_at is not null and ended_at is not null)", @date_from, @date_to, @date_from, @date_to, @date_from, @date_to])
    
    if params[:output]=='pdf'
      @options_for_rfpdf ||= {}
      @options_for_rfpdf[:file_name] = "gantt.pdf"
      render :action => "gantt.rfpdf", :layout => false
    else
      render :action => "gantt.rhtml"
    end
  end
##
# Delete a whole project
# 
  def delete
    @project.events.find(params[:id]).destroy
    render :update do |page|
      page["event-#{params[:id]}"].visual_effect :drop_out
    end
  end 

end
