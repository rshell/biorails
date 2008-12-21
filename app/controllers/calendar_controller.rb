class CalendarController < ApplicationController

  use_authorization :project,
    :use => [:gantt,:show]
  
  before_filter :setup_folder , :only => [ :show, :gantt]
  
  helper :calendar

  # ## Show a overview calendar for the project this should list the
  # experiments, documents etc linked into the project
  # 
  def show
    @options ={ 'month' => Date.today.month,
      'year'=> Date.today.year,
      'items'=> {'task'=>1}, 'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4}}.merge(params)
 
    logger.debug " Calendar for #{@options.to_yaml}"
    started = Date.civil(@options['year'].to_i,@options['month'].to_i,1)   

    @calendar = CalendarData.new(started,1)
    @calendar.add_model_from_folder_tree(Task,@folder,@options['states'])       if @options['items']['task']
    @calendar.add_model_from_folder_tree(Experiment,@folder,@options['states']) if @options['items']['experiment']
    @calendar.add_model_from_folder_tree(Assay,@folder,@options['states'])      if @options['items']['assay']
    @calendar.add_model_from_folder_tree(Request,@folder,@options['states'])    if @options['items']['request']
   
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext  { render :partial =>'calendar'}
      format.json { render :json => {:folder=> @folder, :items=>@calendar.items}.to_json }
      format.xml  { render :xml => {:folder=> @folder,:items=>@calendar.items}.to_xml }
      format.js   { render :update do | page |
          page.replace_html 'center',  :partial => 'calendar' 
          page.replace_html 'status',  :partial => 'calendar_right' 
        end }
      format.ics  { render :text => @calendar.to_ical}
    end
  end  
  
 # ## Display of Gantt chart of task in  the project This will need to show
  # assays,experiments and tasks in order
  # 
  def gantt
    @options ={ 'month' => Date.today.month,
      'year'=> Date.today.year,
      'items'=> {'task'=>1},
      'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4} }.merge(params)
      
    find_options = "state_id in ( #{ @options['states'].keys.join(',') } )"
                    
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
    @tasks =  CalendarData.find_boxed(Task,@folder,@options['states'],@date_from,@date_to)
    
    @options_for_rfpdf ||= {}
    @options_for_rfpdf[:file_name] = "gantt.pdf"

    respond_to do | format |
      format.html { render :action => 'gantt' }
      format.ext { render :action => 'gantt', :layout => false }
      format.pdf { render :action => "gantt_print.rfpdf", :layout => false }
      format.json { render :json => {:project=> @project, :items=>@tasks}.to_json }
      format.xml  { render :xml =>  {:project=> @project,:items=>@tasks}.to_xml }
      format.js   { 
        render :update do | page |
          page.main_panel   :partial => 'gantt' 
          page.status_panel   :partial => 'gantt_status'
        end
      }
    end
  end

protected

  def setup_folder
    if params[:id]
      @folder = ProjectFolder.load(params[:id])
      set_element(@folder)  if @folder  
    else 
      @folder = current_project.home  
    end
    return show_access_denied unless @folder
  end
  
end
