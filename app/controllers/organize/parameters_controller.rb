# ==Paramerer Controller
# This manages the display of a parameter
# 
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
#
class Organize::ParametersController < ApplicationController
  
  use_authorization :organization,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user
                    
  def index
    list
    render :action => 'list'
  end

  def list
   @report = Report.internal_report("ParameterList",Assay) do | report |
      report.column('column_no').is_visible = false
      report.column('sequence_num').is_visible = false
      report.column('display_unit').is_visible = false
      report.column('qualifier_style').is_visible = false
      report.column('process.protocol.assay.name').label= 'assay'
      report.column('process.protocol.name').label ='protocol'
      report.column('process.name').label ='version'
      report.column('data_type.name').label ='data'
      report.column('role.name').label ='role'
      report.column('type.name').label ='type'
      report.column('name').action = :show
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   @data = @report.run(:page => params[:page])
  end
  
  def show
    @parameter = Parameter.find(params[:id])
    protocol_list
    task_metrics
    parameter_results
  end

protected


  def protocol_list
   @report = Report.internal_report("ParameterProtocols",Parameter) do | report |
      report.column('process.protocol.assay.name').label= 'assay'
      report.column('process.protocol.name').label ='protocol'
      report.column('process.name').label ='version'
      report.column('data_type.name').label ='data'
      report.column('role.name').label ='role'
      report.column('type.name').label ='type'
      report.column('id').filter = "#{@parameter.id}"
      report.column('id').is_visible = false
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end  
   @protocol_data = @report.run(:page=>params[:page])
  end


##
# Generate a report on task level statistics filter down to only this parameter type
# 
  def task_metrics
   @report = Report.internal_report("ProcessStatistics",ProcessStatistics) do | report |
      report.column('process.protocol.assay.name').label= 'assay'
      report.column('process.protocol.name').label ='protocol'
      report.column('process.name').label ='version'
      report.column('data_type.name').label ='data'
      report.column('role.name').label ='role'
      report.column('type.name').label ='type'
      report.column('id').filter = "#{@parameter.id}"
      report.column('id').is_visible = false
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end 
   @task_data = @report.run(:page=>params[:page])
  end

##
# Generate a report on task level statistics filter down to only this parameter type
# 
  def parameter_results
   @report = Report.internal_report("ParameterResults",TaskResult) do | report |
      report.column('process.protocol.assay.name').label= 'assay'
      report.column('process.protocol.name').label ='protocol'
      report.column('process.name').label ='version'
      report.column('data_type.name').label ='data'
      report.column('role.name').label ='role'
      report.column('type.name').label ='type'
      report.column('parameter_id').filter = "#{@parameter.id}"
      report.column('parameter_id').is_visible = false
      report.column('parameter_context_id').filter = "#{@parameter.parameter_context_id}"
      report.column('parameter_context_id').is_visible = false
   end 
   @results_data = @report.run(:page=>params[:page])
  end


  
  
end
