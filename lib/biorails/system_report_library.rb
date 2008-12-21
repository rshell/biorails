#
# To change this template, choose Tools | Templates
# and open the template in the editor.


module Biorails
  module SystemReportLibrary

    #
    # Used a s list /admin/reports/list
    #
    def self.system_report_list(name, &block)
      SystemReport.internal_report(name,Report) do | report |
        report.column('name',        :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description', :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('base_model',  :order_num=>3,:label=>:model,:is_filterible=>true,:is_visible=>true)
        report.column('style',       :order_num=>5,:label=>:style,:filter=>'System',:is_visible=>false)
        yield report if block_given?
      end
    end

    def self.queue_results(name, &block )
      report = SystemReport.internal_report(name,QueueResult) do | report |
        report.column('queue.assay.project.name', :label=>'Project',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('queue.assay.name',         :label=>'Assay',  :is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('queue.name',               :label=>'Queue',  :is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('process.name',             :label=>'Process',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('service.name',             :label=>'Service',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('service.request.name',     :label=>'Request',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('task.name',                :label=>'Task',   :is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('definition.label',         :label=>'Label',  :is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('parameter.name',         :label=>'Parameter',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('subject',                  :label=>'Subject',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('data_type',                :label=>'Type',   :is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('data_value',               :label=>'Value',  :is_filterible=>'true',:is_visible=>'true',:filter=>'')
        yield report if block_given?
      end
    end

    def self.task_list(name, &block)
      SystemReport.internal_report(name,Task) do | report |
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

    def self.project_content_list(name, &block)
      SystemReport.internal_report(name, ProjectContent) do | report |
        report.column('id', :label=>'Id',:is_filterible=>'false',:is_visible=>'false',:filter=>'')
        report.column('name',       :label=>'Name',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('path',       :label=>'Path',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('state.name', :label=>'State',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('updated_by', :label=>'Updated_by',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('updated_at', :label=>'Updated_at',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
      end
    end

    def self.project_file_list(name, &block)
      SystemReport.internal_report(name, ProjectAsset) do | report |
        report.column('id', :label=>'Id',:is_filterible=>'false',:is_visible=>'false',:filter=>'')
        report.column('icon',       :label=>'Icon',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('name',       :label=>'Name',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('asset.size_bytes', :label=>'Size',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('path',       :label=>'Path',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('state.name', :label=>'State',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('updated_by', :label=>'Updated_by',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('updated_at', :label=>'Updated_at',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
      end
    end

    def self.internal_signed_elements_within( name ,folder, &block)
      SystemReport.internal_report(name,Signature) do | report |
        report.column('project_element.name', :label=>'Name',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('project_element.reference_type', :label=>'Reference',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('project_element.path', :label=>'Path',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('signature_role', :label=>'role',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('signature_state', :label=>'state',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('signer.name', :label=>'Signer Name',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('id', :label=>'Id',:is_filterible=>'false',:is_visible=>'false',:filter=>'')
        report.column('project_element.state.name', :label=>'Content State',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('reason', :label=>'Reason',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('updated_at', :label=>'Updated_at',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('project_element.project', :label=>'container',:is_filterible=>'false',
          :is_visible=>'false',:filter=>"#{folder.project_id}")
        report.column('project_element.left_limit', :label=>'Left_limit',:is_filterible=>'false',
          :is_visible=>'false',:filter=>">#{folder.left_limit}")
        report.column('project_element.right_limit', :label=>'Right_limit',:is_filterible=>'false',
          :is_visible=>'false',:filter=>"<#{folder.right_limit}")
        yield report if block_given?
      end
    end

    def self.internal_signed_elements( name ,folder, &block)
      SystemReport.internal_report(name,Signature) do | report |
        report.column('project_element.name', :label=>'Name',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('project_element.reference_type', :label=>'Reference',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('project_element.path', :label=>'Path',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('signature_role', :label=>'role',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('signature_state', :label=>'state',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('signer.name', :label=>'Signer Name',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('id', :label=>'Id',:is_filterible=>'false',:is_visible=>'false',:filter=>'')
        report.column('project_element.state.name', :label=>'Content State',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('reason', :label=>'Reason',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('updated_at', :label=>'Updated_at',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        yield report if block_given?
      end
    end

    def self.projects_list( name, &block)
      SystemReport.internal_report(name,Project) do | report |
        report.description = name
        report.column('name',:order_num=>1,:label=>'Name',:is_filterible=>true,:is_visible=>true)
        report.column('project_element.path',:order_num=>1,:label=>'Path',:is_filterible=>false,:is_visible=>true)
        report.column('description', :order_num=>2,:label=>'Desc.',:is_filterible=>false,:is_visible=>true)
        report.column('started_at',:order_num=>3,:label=>'Started',:is_filterible=>true,:is_visible=>true)
        report.column('expected_at',:order_num=>4,:label=>'Expected',:is_filterible=>true,:is_visible=>true)
        report.column('ended_at',:order_num=>5,:label=>'Ended',:is_filterible=>true,:is_visible=>true)
        report.column('project_type.name',:order_num=>6,:label=>'Type',:is_filterible=>true,:is_visible=>true, :sort_num=> 0, :sort_desc=> 'asc')
        report.column('project_type.state_flow.name', :order_num=>7,:label=>'State Flow',:is_filterible=>true,:is_visible=>true)
        report.column('team.name', :order_num=>8,:label=>'Team',:is_filterible=>true,:is_visible=>true)
        report.column('project_element.state.name', :order_num=>9,:label=>'Status',:is_filterible=>true,:is_visible=>true)
        report.column('id', :order_num=>10,:is_filterible=>true,:is_visible=>false)
        yield report if block_given?
      end
    end

    def self.domains_list(name, &block)
      SystemReport.internal_report(name,Project) do | report |
        report.column('name',     :label=>'Name',   :is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('title',    :label=>'Title',  :is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('project_element.state.name', :label=>'State',:is_filterible=>'true',:filter=>"=new",:is_visible=>'true',:filter=>'')
        report.column('team.name', :label=>'Team',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('project_type.name', :label=>'Project_type',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('id',        :label=>'Id',:is_filterible=>'false',:is_visible=>'false',:filter=>'')
        yield report if block_given?
      end
    end

    def self.approved_documents(name, &block)
      SystemReport.internal_report(name, Signature) do | report |
        report.column('signature_role', :label=>'Signature_role',:is_filterible=>'true',:is_visible=>'false',:filter=>'WITNESS')
        report.column('signer.name', :label=>'Approver',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('creator.fullname', :label=>'Fullname',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('comments', :label=>'Comments',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('project_element.name', :label=>'Project_element Name',:is_filterible=>'true',:is_visible=>'true',:filter=>'')
        report.column('id', :label=>'Id',:is_filterible=>'false',:is_visible=>'false',:filter=>'')
        report.column('signed_date', :label=>'Date',:is_filterible=>'false',:is_visible=>'true',:filter=>'')
        report.column('signature_state', :label=>'Signature_state',:is_filterible=>'true',:is_visible=>'false',:filter=>'SIGNED')
        yield report if block_given?
      end
    end

    #
    #  Systems Level Reports
    #
    def self.user_request_list(name, &block)
      SystemReport.internal_report(name,Request) do | report |
        report.column('name',             :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description',      :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('requested_by.name',:order_num=>3,:label=>:by,:is_filterible=>true,:is_visible=>true)
        report.column('data_element.name',:order_num=>4,:label=>:for,:is_filterible=>true,:is_visible=>true)
        report.column('started_at',       :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at',      :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project.name',     :order_num=>7,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('assigned_to_user_id').is_visible = false
        report.column('project_id').is_visible = false
        yield report if block_given?
      end
    end

    def self.user_queued_items_list(name, &block)
      SystemReport.internal_report(name,QueueItem) do | report |
        report.column('name',             :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description',      :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('requested_by.name',:order_num=>3,:label=>:by,:is_filterible=>true,:is_visible=>true)
        report.column('data_element.name',:order_num=>4,:label=>:for,:is_filterible=>true,:is_visible=>true)
        report.column('started_at',       :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at',      :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project.name',     :order_num=>7,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('assigned_to_user_id').is_visible = false
        report.column('project_id').is_visible = false
        yield report if block_given?
      end
    end


    #
    # Support functions
    #
    def self.state_flow_list( &block)
      flow_report = SystemReport.internal_report("State Flow List",StateFlow) do | report |
        report.description = "State Flow"
        report.column('name',          :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description',   :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('used?',         :order_num=>3,:label=>'in_use',:is_visible=>true)     end
      yield flow_report if block_given?
      return flow_report
    end

 

  end
end
