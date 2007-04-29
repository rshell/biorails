class HomeController < ApplicationController

  use_authorization :home,
                    :actions => [:index,:show,:projects,:calendar,:timeline,:blog,:destroy],
                    :rights => :current_user  

  helper :calendar
  
  def index
    show
  end

  def show
    @user = current_user    
    respond_to do | format |
      format.html { render :action => 'show'}
      format.xml {render :xml =>  @user.to_xml(:include=>[:projects,:tasks,:requested_services,:queue_items])}
    end
  end

  def projects
    @user = current_user    
    respond_to do | format |
      format.html { render :action => 'projects'}
      format.xml  { render :xml =>  @user.to_xml(:include=>[:projects])}
    end
  end


  def calendar
    @options ={ 'month' => Date.today.month,
                'year'=> Date.today.year,
                'items'=> {'task'=>1},
                'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4} }.merge(params)
    @user = current_user

    logger.info " Calendar for #{@options.to_yaml}"

    started = Date.civil(@options['year'].to_i,@options['month'].to_i,1)   

    find_options = {:conditions=> "status_id in ( #{ @options['states'].keys.join(',') } )"}

    @schedule = CalendarData.new(started,1)
    @user.tasks.add_into(@schedule,find_options)               if @options['items']['task']
    @user.experiments.add_into(@schedule,find_options)         if @options['items']['experiment']
    @user.requested_services.add_into(@schedule,find_options)  if @options['items']['request']
    @user.queue_items.add_into(@schedule,find_options)         if @options['items']['queue']

    respond_to do | format |
      format.html { render :action => 'calendar' }
      format.js    { render :action => 'calendar', :layout => false }
      #format.ical  { render :text => @schedule.to_ical}
    end
  end

##
#
  def timeline
    @master = current_user
    @gnatt = Schedule.new(Task)
    @gnatt.gnatt(params)
    render :layout => false if request.xhr?
  end

##
# List of list 20 pieces of information added by the user
#
  def blog
    @user = current_user
    @elements = ProjectElement.find(:conditions=>["created_by = ? or updated_by = ?",@user.id,@user.id],
                                    :order=>'updated_by,created_by',:limit=>20 )
    render :layout => false if request.xhr?
  end  
  
        
protected 
  def context
    @user = current(user,params[:id])     
  end
    
end
