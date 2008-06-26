# ##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##

#
# User Dashboard controller
#
class HomeController < ApplicationController

  use_authorization :home,
    :actions => [:index,:show,:projects,:calendar,:timeline,:blog,:destroy],
    :rights => :current_user  

  helper :calendar
  DEFAULT_CALENDAR_OPTIONS = {  'month' => Date.today.month,
    'year'=> Date.today.year,
    'items'=> {'task'=>1},
    'states' =>{'0'=>'new','1'=>'accepted','2'=>'waiting','3'=>'processing','4'=>'validation'} } unless defined? DEFAULT_CALENDAR_OPTIONS
                  
  def index
    show
  end
  # 
  # Show the default user dashboard
  # 
  def show
    @user = current_user    
    @signatures_authored_by = Signature.find_authored_by(@user.id, 5)
    @signatures_for_witness = Signature.find_pending_witness_for(@user.id, 5)
    @signatures_to_witness = Signature.find_pending_witness_by(@user.id, 5)
    flash[:notice]='This user has no published document' unless  current_user.has_published_documents?

    respond_to do | format |
      format.html { render :action => 'show'}
      format.xml {render :xml =>  @user.to_xml()}
    end
  end
  # 
  # List news for the user
  # 
  def news
    @user = current_user    
    @report = Report.internal_report("My News",ProjectElement) do | report |
      report.column('updated_by_user_id').filter = @user.id
      report.column('project_id').is_visible = false
      report.column('published_hash').is_visible = false
      report.column('id').is_visible = false
      report.column('left_limit').is_visible = false
      report.column('right_limit').is_visible = false
      report.column('position').is_visible = false
      report.column('project.name').customize(:is_visible=>true,:order_num=>1)
      report.column('name').action = :show
      report.column('path').is_sortable = false
      report.column('icon').is_visible = false
      report.column('summary').is_sortable = false
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
    end
    @data = @report.run(:page => params[:page])
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @data.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report, :data =>@data } 
        end 
      }
    end
  end

  def todo
    @user = current_user 
    @report = Report.internal_report("'s Queued Items",QueueItem) do | report |
      report.column('assigned_to_user_id').filter = @user.id
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
      report.column('name').action = :show
    end
    @report.column('id').is_visible = false
    @data = @report.run(:page => params[:page])
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @data.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report, :data =>@data } 
        end 
      }
    end
  end

  def requests
    @user = current_user    
    @report = Report.internal_report("My Requested List",QueueItem) do | report |
      report.column('requested_by_user_id').filter = @user.id
      report.column('id').is_visible = false
      report.column('name').action = :show
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
    end
    @data = @report.run(:page => params[:page])
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @data.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report, :data =>@data } 
        end 
      }
    end
  end

  def tasks
    @user = current_user    
    @report = Report.internal_report("My Tasks",Task) do | report |
      report.column('created_by_user_id').filter = @user.id
      report.column('id').is_visible = false
      report.column('name').action = :show
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
    end
    @data = @report.run(:page => params[:page])
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @data.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report, :data =>@data } 
        end 
      }
    end
  end


  # ## Generate a calendar in a number of formats
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
      # @todo enable mime etc for ical     format.ical  { render :text =>
      # @calendar.to_ical }
      format.js   { 
        render :update do | page |
          page.replace_html 'center',  :partial => 'calendar' 
          page.replace_html 'status',  :partial => 'calendar_right' 
        end 
      }
    end
  end
  


  # Display of Gantt chart of task in  the project This will need to show
  # assays,experiments and tasks in order
  # 
  def gantt
    @user = current_user
    @options ={ 'month' => Date.today.month,
      'year'=> Date.today.year,
      'items'=> {'task'=>1},
      'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4} }.merge(params)
    find_options = {:conditions=> "status_id in ( #{ @options['states'].keys.join(',') } )"}
                    
    if params[:year] and params[:year].to_i >0
      @year_from = params[:year].to_i
      if params[:month] and params[:month].to_i >=1 and params[:month].to_i <= 12
        @month_from = params[:month].to_i
      end
    else
      @month_from ||= (Date.today << 1).month
      @year_from ||= (Date.today << 1).year
    end
    
    @zoom = (params[:zoom].to_i > 0 and params[:zoom].to_i < 5) ? params[:zoom].to_i : 2
    @months = (params[:months].to_i > 0 and params[:months].to_i < 25) ? params[:months].to_i : 6
    
    @date_from = Date.civil(@year_from, @month_from, 1)
    @date_to = (@date_from >> @months) - 1
    @tasks = current_user.tasks.range( @date_from, @date_to,50,find_options)  

    render :action => "gantt.rhtml"
  end

  # 
  # Create a Tree data model
  # 
  def tree
    if params[:node] != 'root'
      @elements = current_user.element(:all, :conditions =>['parent_id = ?',params[:node] ],:order=>:left_limit)
    else  
      @elements = current_user.element(:all,:conditions=>'parent_id is null',:order=>:name)
    end
    respond_to do | format |
      format.html { render :partial => 'tree'}
      format.json { render :partial => 'tree'}
    end
  end

end
