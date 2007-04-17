class Study::ParametersController < ApplicationController
  
  use_authorization :protocol,
                    :actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
                    :rights => :current_project
                    
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
   @report = Report.find_by_name("ParameterList") 
   unless @report
      @report = report_list_for("ParameterList",Parameter)

      @report.column('column_no').is_visible = false
      @report.column('sequence_num').is_visible = false
      @report.column('display_unit').is_visible = false
      @report.column('qualifier_style').is_visible = false
      @report.column('process.protocol.study.name').label= 'study'
      @report.column('process.protocol.name').label ='protocol'
      @report.column('process.name').label ='version'
      @report.column('data_type.name').label ='data'
      @report.column('role.name').label ='role'
      @report.column('type.name').label ='type'
      @report.save
   end  
   @report.params[:controller]='parameters'
   @report.params[:action]='show'
   @report.set_filter(params[:filter])if params[:filter] 
   @report.add_sort(params[:sort]) if params[:sort]

   @data_pages = Paginator.new self, 1000, 100, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page,
                        :offset =>  @data_pages.current.offset })

  end

  def show
    @parameter = Parameter.find(params[:id])
    protocol_list
    task_metrics
    parameter_results
  end

protected

  def protocol_list
   @protocol_report = Report.find_by_name("ParameterProtocols") 
   unless @protocol_report
      @protocol_report = report_list_for("ParameterProtocols",Parameter)
      @protocol_report.save
   end  
   @protocol_report.column('id').filter = "#{@parameter.id}"
   @protocol_report.column('id').is_visible = false
   @protocol_data = @protocol_report.run({:limit  =>  32})
  end


##
# Generate a report on task level statistics filter down to only this parameter type
# 
  def task_metrics
   @task_report = Report.find_by_name("TaskStatistics") 
   unless @task_report
      @task_report = report_list_for("TaskStatistics",ProcessStatistics)
      @task_report.save
   end  
   @task_report.column('parameter_id').filter = "#{@parameter.id}"
   @task_report.column('parameter_id').is_visible = false
   @task_data = @task_report.run({:limit  =>  32})
  end

##
# Generate a report on task level statistics filter down to only this parameter type
# 
  def parameter_results
   @results_report = Report.find_by_name("ParameterResults") 
   unless @results_report
      @results_report = report_list_for("ParameterResults",TaskResult)
      @results_report.save
   end  
   @results_report.column('parameter_id').filter = "#{@parameter.id}"
   @results_report.column('parameter_id').is_visible = false
   @results_report.column('parameter_context_id').filter = "#{@parameter.parameter_context_id}"
   @results_report.column('parameter_context_id').is_visible = false
   @results_data = @task_report.run({:limit  =>  32})
  end


  
  
end
