# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module Biorails
  module ReportLibrary
    #
    # Project Level Reports
    #
    def self.request_list( &block)
      ProjectReport.project_report("Project Requests",Request) do | report |
        report.column('name',             :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('requested_by.name',:order_num=>3,:label=>:by,:is_filterible=>true,:is_visible=>true)
        report.column('data_element.name',:order_num=>4,:label=>:for,:is_filterible=>true,:is_visible=>true)
        report.column('started_at',       :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at',      :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project.name',     :order_num=>7,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('project_id',    :order_num=>11,:is_filterible=>true,:is_visible=>false,:filter => Project.current.id.to_s)
        yield report if block_given?
      end
    end

    def self.request_results_list(request, &block)
      name ||= "Request Results #{request.name}"
      ProjectReport.project_report(name,QueueResult) do | report |
        report.column('service.name',   :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('queue.name',      :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('subject',         :order_num=>3,:is_filterible=>true,:is_visible=>true)
        report.column('label',           :order_num=>4,:is_filterible=>true,:is_visible=>true)
        report.column('parameter_name',  :order_num=>5,:is_filterible=>true,:is_visible=>true)
        report.column('data_value',      :order_num=>6,:is_filterible=>true,:is_visible=>true)
        report.column('task.name',       :order_num=>7,:is_filterible=>true,:is_visible=>true)
        report.column('id',              :order_num=>8,:is_filterible=>true,:is_visible=>false)
        report.column('task.status_id',  :order_num=>9,:filter => "5",:is_visible => false)
        report.column('service.request_id',   :order_num=>10,:filter=>request.id,:is_filterible=>true,:is_visible=>false)
        report.column('assay.project_id',    :order_num=>11,:is_filterible=>true,:is_visible=>false,:filter => Project.current.id.to_s)
        yield report if block_given?
      end
    end

    def self.request_service_results_list(request, &block)
      name ||= "Service Results #{request.name}"
      ProjectReport.project_report(name,QueueResult) do | report |
        report.column('service.name',   :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('queue.name',      :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('subject',         :order_num=>3,:is_filterible=>true,:is_visible=>true)
        report.column('label',           :order_num=>4,:is_filterible=>true,:is_visible=>true)
        report.column('parameter_name',  :order_num=>5,:is_filterible=>true,:is_visible=>true)
        report.column('data_value',      :order_num=>6,:is_filterible=>true,:is_visible=>true)
        report.column('task.name',       :order_num=>7,:is_filterible=>true,:is_visible=>true)
        report.column('id',              :order_num=>8,:is_filterible=>true,:is_visible=>false)
        report.column('task.status_id',  :order_num=>9,:filter => "5",:is_visible => false)
        report.column('service.id',   :order_num=>10,:filter=>request.id,:is_filterible=>true,:is_visible=>false)
        yield report if block_given?
      end
    end

    def self.report_list( &block)
      ProjectReport.project_report("Project Reports",Report) do | report |
        report.column('name',        :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description', :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('base_model',  :order_num=>3,:label=>:model,:is_filterible=>true,:is_visible=>true)
        report.column('project.name',:order_num=>4,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('style',       :order_num=>5,:label=>:style,:filter=>'Project',:is_visible=>false)
        report.column('project_id',       :order_num=>9,:label=>:project_id,
          :is_filterible=>true,:is_visible=>false,
          :filter => Project.current.id.to_s)
        yield report if block_given?
      end
    end

    def self.assay_list( &block)
      ProjectReport.project_report("Project Assays",Assay) do | report |
        report.column('name',          :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description',   :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('project.name',  :order_num=>3,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('project_element.state.name',:order_num=>4,:label=>:state,:is_filterible=>true,:is_visible=>true)
        report.column('started_at',    :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at',   :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project_id',       :order_num=>9,:label=>:project_id,
          :is_filterible=>true,:is_visible=>false,
          :filter => Project.current.id.to_s)
        yield report if block_given?
      end
    end


    def self.task_list( &block)
      ProjectReport.project_report("Project Tasks",Task) do | report |
        report.column('experiment.name',:order_num=>1,:label=>:experiment,:is_filterible=>true,:is_visible=>true)
        report.column('name',          :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('project.name',  :order_num=>3,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('team.name',     :order_num=>4,:label=>:team,:is_filterible=>true,:is_visible=>true)
        report.column('assigned_to.name', :order_num=>5,:label=>:assigned_to,:is_filterible=>true,:is_visible=>true)
        report.column('process.name',  :order_num=>7,:label=>:process,:is_filterible=>true,:is_visible=>true)
        report.column('project_element.state.name',:order_num=>8,:label=>:state,:is_filterible=>true,:is_visible=>true)
        report.column('started_at',    :order_num=>9,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at',   :order_num=>10,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project_id',    :order_num=>11,:is_filterible=>true,:is_visible=>false,:filter => Project.current.id.to_s)
        report.column('id').is_visible = false
        report.column('is_milestone').is_visible = false
        report.column('done_hours').is_visible = false
        yield report if block_given?
      end
    end
    #
    # Used in assays/experiments/id
    #
    def self.experiment_list(name, &block)
      ProjectReport.project_report(name,Experiment) do | report |
        report.description = "Experiments in a Assay"
        report.column('name',                      :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description',               :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('project.name',              :order_num=>3,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('project_element.state.name',:order_num=>4,:label=>:state,:is_filterible=>true,:is_visible=>true)
        report.column('started_at',                :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at',               :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('status_summary',            :order_num=>7,:is_visible => true,:label=>'summary')
        report.column('assay.id',                  :order_num=>8,:label=>:Assay,:is_filterible=>true,:is_visible=>false)
        report.column('project_id',    :order_num=>11,:is_filterible=>true,:is_visible=>false,:filter => Project.current.id.to_s)
        yield report  if block_given?
      end
    end

    def self.parameter_list(name, &block)
      ProjectReport.project_report(name,Parameter) do | report |
        report.column('process.protocol.assay.name', :order_num=>1,:label=>'Name',:is_filterible=>true,:is_visible=>true)
        report.column('process.name',  :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('role.name',     :order_num=>3,:label=>'Role',:is_filterible=>true,:is_visible=>true)
        report.column('data_type.name',:order_num=>4,:label=>'Date',:is_filterible=>true,:is_visible=>true)
        report.column('type.name',     :order_num=>5,:label=>'Type',:is_filterible=>true,:is_visible=>true)
        report.column('name',          :order_num=>6,:label=>'Name',:is_filterible=>true,:is_visible=>true)
        report.column('context.label', :order_num=>7,:label=>'Context',:is_filterible=>true,:is_visible=>true)
        report.column('assay_parameter_id',:is_filterible=>'true',:is_visible=>'false',:filter=>'')
        report.column('protocol_version_id',:is_filterible=>'true',:is_visible=>'false',:filter=>'')
        report.column('parameter_type_id',:is_filterible=>'true',:is_visible=>'false',:filter=>'')
        report.column('parameter_role_id',:is_filterible=>'true',:is_visible=>'false',:filter=>'')
        yield report  if block_given?
      end
    end
    #
    # used in assays/parameters/id
    #
    def self.assay_parameter_list(name, &block)
      ProjectReport.project_report(name,AssayParameter) do | report |
        report.column('name',          :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description',   :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('type.name',     :order_num=>3,:label=>'Type',:is_filterible=>true,:is_visible=>true)
        report.column('data_type.name',:order_num=>4,:label=>'Data Type',:is_filterible=>true,:is_visible=>true)
        report.column('role.name',     :order_num=>5,:label=>'Role',:is_filterible=>true,:is_visible=>true)
        yield report if block_given?
      end
    end
    #
    # Used in assays/processes/id
    #
    def self.assay_processes_list( name, &block)
      ProjectReport.project_report(name,ProcessInstance) do | report |
        report.description = "Processes in an Assay"
        report.column('name',              :order_num=>1,:label => 'Name',       :is_filterible=>true, :is_visible=>true)
        report.column('description',       :order_num=>2,:label => 'Description',:is_filterible=>false,:is_visible=>true)
        report.column('id',                :order_num=>3,:label => 'id',         :is_filterible=>false,:is_visible=>false)
        report.column('status',            :order_num=>4,:label => 'Status',     :is_filterible=>true, :is_visible=>true)
        report.column('version',           :order_num=>5,:label => 'Version',    :is_filterible=>false, :is_visible=>true)
        report.column('protocol.assay.id', :order_num=>6,                        :is_filterible=>true, :is_visible=>true)
        yield report if block_given?
      end
    end
    #
    # Used in assayts/queues/id
    #
    def self.assay_queue_list(name, &block)
      ProjectReport.project_report(name,AssayQueue) do | report |
        report.description = "Queues in an Assay"
        report.column('name',                :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description',         :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('priority',            :order_num=>3,:label=>'Priority',:is_filterible=>true,:is_visible=>true)
        report.column('status',              :order_num=>4,:label=>'Status',:is_filterible=>true,:is_visible=>true)
        report.column('parameter.name',      :order_num=>5,:label=>'Parameter',:is_filterible=>true,:is_visible=>true)
        report.column('created_by_user.name',:order_num=>6,:label=>'Created_by',:is_filterible=>true,:is_visible=>true)
        report.column('assigned_to.name',    :order_num=>7,:label=>'Assigned',:is_filterible=>true,:is_visible=>true)
        yield report if block_given?
      end
    end
    #
    # Used in assays/recipes/id
    #
    def self.assay_recipe_list(name, &block)
      ProjectReport.project_report(name,ProcessFlow) do | report |
        report.description = "Recipes in an Assay"
        report.column('name',               :order_num=>1,:label => 'Name',        :is_filterible=>true, :is_visible=>true)
        report.column('description',        :order_num=>2,:label => 'Description', :is_filterible=>false,:is_visible=>true)
        report.column('status',             :order_num=>3,:label => 'Status',      :is_filterible=>true, :is_visible=>true)
        report.column('version',            :order_num=>4,:label => 'Version',     :is_filterible=>true, :is_visible=>true)
        report.column('protocol.assay.id',  :order_num=>5,:label=>'Created_by',    :is_filterible=>true, :is_visible=>false)
        yield report if block_given?
      end
    end

    def self.assay_statistics(name,&block)
      ProjectReport.project_report(name,AssayStatistics) do | report |
        report.column('assay.name', :label=>'Assay',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('assay.project.name', :label=>'Project',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('role.name', :label=>'Role',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('type.name', :label=>'Type',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('assay_parameter.name', :label=>'Name',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('num_values', :label=>'Num',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('avg_values', :label=>'Avg',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('min_values', :label=>'Min',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('max_values', :label=>'Max',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('assay_parameter_id',:is_filterible=>'true',:is_visible=>'false',:filter=>'')
        report.column('id', :label=>'Id',:is_filterible=>'false',:is_visible=>'false',:filter=>'')
      end
    end
    ##
    # Generate a report on task level statistics filter down to only this parameter type
    #
    def self.process_statistics(name, &block)
      ProjectReport.project_report(name,ProcessStatistics) do | report |
        report.column('process.name',  :label=>'Process',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('role.name', :label=>'Role',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('type.name', :label=>'Type',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('parameter.name', :label=>'Name',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('num_values', :label=>'Num',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('avg_values', :label=>'Avg',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('min_values', :label=>'Min',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('max_values', :label=>'Max',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('assay_parameter_id',:is_filterible=>'true',:is_visible=>'false',:filter=>'')
        report.column('id', :label=>'Id',:is_filterible=>'false',:is_visible=>'false',:filter=>'')
        yield report if block_given?
      end
    end

    ##
    # Generate a report on task level statistics filter down to only this parameter type
    #
    def self.experiment_statistics(name, &block)
      ProjectReport.project_report(name,ExperimentStatistics) do | report |
        report.column('experiment.project.name', :label=>'Project',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('experiment.name',  :label=>'Experiment',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('role.name', :label=>'Role',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('type.name', :label=>'Type',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('assay_parameter.name', :label=>'Name',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('assay_parameter.display_unit', :label=>'Display_unit',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('num_values', :label=>'Num',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('avg_values', :label=>'Avg',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('min_values', :label=>'Min',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('max_values', :label=>'Max',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('id', :label=>'Id',:is_filterible=>'true',:is_visible=>'false',:filter=>'')
        report.column('assay_parameter_id',:is_filterible=>'true',:is_visible=>'false',:filter=>'')
        yield report if block_given?
      end
    end

    ##
    # Generate a report on task level statistics filter down to only this parameter type
    #
    def self.task_statistics(name, &block)
      ProjectReport.project_report(name,TaskStatistics) do | report |
        report.column('process.protocol.assay.name').label= 'assay'
        report.column('process.protocol.name').label ='protocol'
        report.column('process.name').label ='version'
        report.column('data_type.name').label ='data'
        report.column('role.name').label ='role'
        report.column('type.name').label ='type'
        yield report if block_given?
      end
    end

    ##
    # Generate a report on task level statistics filter down to only this parameter type
    #
    def self.task_results(name, &block)
      ProjectReport.project_report(name,TaskResult) do | report |
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
        yield report if block_given?
      end
    end
    
  end
end
