class Project::OverviewController < Project::BaseController
  member_actions << 'index' << 'feed'
  session :off, :only => :feed
  before_filter :basic_auth_required, :only => :feed
  caches_page :feed
  helper :sort
  include SortHelper	
  
  helper Project::ArticlesHelper
  
  def index
    @users = current_project.members
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

  def show
    @project = Project.find(params[:id])
  end


  def studies
     @project = current_project
     sort_init 'name'
     sort_update
     @item_pages, @items = paginate :studies, :order_by => sort_clause, :per_page => 20
     render :action => "studies", :layout => false if request.xhr?
  end

  def experiments
     @project = current_project
     sort_init 'name'
     sort_update
     @item_pages, @items = paginate :experiments,  :order_by => sort_clause, :per_page => 20
     render :action => "experiments", :layout => false if request.xhr?
  end

  def reports
     @project = current_project
     sort_init 'name'
     sort_update
     @item_pages, @items = paginate :reports, :order_by => sort_clause, :per_page => 20
     render :action => "reports", :layout => false if request.xhr?
  end

##
# Show a 
  def calendar
     @project = current_project
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
      
    @tasks = Task.find(:all, :order => "start_date, end_date", :include => [:experiment], 
                         :conditions => ["(((start_date>=? and start_date<=?) or (end_date>=? and end_date<=?) or (start_date<? and end_date>?)) and start_date is not null and end_date is not null)", @date_from, @date_to, @date_from, @date_to, @date_from, @date_to])
    
    render :layout => false if request.xhr?
  end  

##
# Display of Gantt chart of task in  the project
# This will need to show studies,experiments and tasks in order
#   
  def gantt
     @project = current_project
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

    @tasks = Task.find(:all, :order => "start_date, end_date", :include => [:experiment], 
                         :conditions => ["(((start_date>=? and start_date<=?) or (end_date>=? and end_date<=?) or (start_date<? and end_date>?)) and start_date is not null and end_date is not null)", @date_from, @date_to, @date_from, @date_to, @date_from, @date_to])
    
    if params[:output]=='pdf'
      @options_for_rfpdf ||= {}
      @options_for_rfpdf[:file_name] = "gantt.pdf"
      render :action => "gantt.rfpdf", :layout => false
    else
      render :action => "gantt.rhtml"
    end
  end

  def feed
    @events = @project.events.find(:all, :order => 'events.created_at DESC', :include => [:article, :user], :limit => 25)
    render :layout => false
  end
  
  def delete
    @project.events.find(params[:id]).destroy
    render :update do |page|
      page["event-#{params[:id]}"].visual_effect :drop_out
    end
  end
end
