class HomeController < ApplicationController

  use_authorization :home,
                    :actions => [:index,:show,:projects,:calendar,:timeline,:blog,:destroy],
                    :rights => :current_user  

  helper :calendar
  
  DEFAULT_CALENDAR_OPTIONS = {  'month' => Date.today.month,
                                'year'=> Date.today.year,
                                'items'=> {'task'=>1},
                                'states' =>{'0'=>'new','1'=>'accepted','2'=>'waiting','3'=>'processing','4'=>'validation'} }
                  
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

##
# Generate a calendar in a number of formats
# 
  def calendar
    @user = current_user
    
    @options = DEFAULT_CALENDAR_OPTIONS.merge(params)
    started = Date.civil(@options['year'].to_i,@options['month'].to_i,1)   

    find_options = {:conditions=> "status_id in ( #{ @options['states'].keys.join(',') } )"}

    @calendar = CalendarData.new(started,1)
    @user.tasks.add_into(@calendar,find_options)               if @options['items']['task']
    @user.experiments.add_into(@calendar,find_options)         if @options['items']['experiment']
    @user.requested_services.add_into(@calendar,find_options)  if @options['items']['request']
    @user.queue_items.add_into(@calendar,find_options)         if @options['items']['queue']

    respond_to do | format |
      format.html { render :action => 'calendar' }
      format.json { render :json => {:user=>@user,:items=>@calendar.items}.to_json }
      format.xml  { render :xml => {:user=>@user,:items=>@calendar.items}.to_xml }
      format.js   { render :update do | page |
           page.replace_html 'centre',  :partial => 'calendar' 
           page.replace_html 'right',  :partial => 'calendar_right' 
         end }
      #format.ical  { render :text => >@calendar@user.calendar.to_ical}
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
