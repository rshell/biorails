# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module Biorails
  module ReportLibrary
 
    def self.project_request_list( &block) 
     request_report = internal_report("Project Requests",Request) do | report |
        report.column('name').customize(             :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description').customize(      :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('requested_by.name').customize(:order_num=>3,:label=>:by,:is_filterible=>true,:is_visible=>true)
        report.column('data_element.name').customize(:order_num=>4,:label=>:for,:is_filterible=>true,:is_visible=>true)
        report.column('started_at').customize(       :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at').customize(      :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project.name').customize(     :order_num=>7,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('project_id').is_visible = false
     end 
     yield request_report if block_given?        
     return request_report
   end

   def self.user_request_list( &block) 
     request_report = internal_report("Project Requests",Request) do | report |
        report.column('name').customize(             :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description').customize(      :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('requested_by.name').customize(:order_num=>3,:label=>:by,:is_filterible=>true,:is_visible=>true)
        report.column('data_element.name').customize(:order_num=>4,:label=>:for,:is_filterible=>true,:is_visible=>true)
        report.column('started_at').customize(       :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at').customize(      :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project.name').customize(     :order_num=>7,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('assigned_to_user_id').is_visible = false
        report.column('project_id').is_visible = false
     end 
     yield request_report if block_given?        
     return request_report
   end

     def self.user_queued_items_list( &block) 
     request_report = internal_report("User Queued Items",QueueItem) do | report |
        report.column('name').customize(             :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description').customize(      :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('requested_by.name').customize(:order_num=>3,:label=>:by,:is_filterible=>true,:is_visible=>true)
        report.column('data_element.name').customize(:order_num=>4,:label=>:for,:is_filterible=>true,:is_visible=>true)
        report.column('started_at').customize(       :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at').customize(      :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project.name').customize(     :order_num=>7,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('assigned_to_user_id').is_visible = false
        report.column('project_id').is_visible = false
     end 
     yield request_report if block_given?        
     return request_report
   end
   
   def self.request_results_list(&block)
      request_results_report = internal_report("Request Results",QueueResult) do | report |
        report.column('service.name').customize(   :order_num=>1,:is_filterible=>true,:is_visible=>true) 
        report.column('queue.name').customize(      :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('subject').customize(         :order_num=>3,:is_filterible=>true,:is_visible=>true)
        report.column('label').customize(           :order_num=>4,:is_filterible=>true,:is_visible=>true)
        report.column('parameter_name').customize(  :order_num=>5,:is_filterible=>true,:is_visible=>true)
        report.column('data_value').customize(      :order_num=>6,:is_filterible=>true,:is_visible=>true)
        report.column('task.name').customize(       :order_num=>7,:is_filterible=>true,:is_visible=>true)
        report.column('id').customize(              :order_num=>8,:is_filterible=>true,:is_visible=>false) 
        report.column('task.status_id').customize(  :order_num=>9,:filter => "5",:is_visible => false)
        report.column('service.request_id').customize(   :order_num=>10,:is_filterible=>true,:is_visible=>false) 
      end
      yield request_results_report if block_given?        
     return request_results_report
    end
   
    def self.report_list( &block) 
     public_report = internal_report("Project Reports",Report) do | report |
        report.column('name').customize(        :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description').customize( :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('base_model').customize(  :order_num=>3,:label=>:model,:is_filterible=>true,:is_visible=>true)
        report.column('project.name').customize(:order_num=>4,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('style').customize(       :order_num=>5,:label=>:style,:filter=>'Report',:is_visible=>false)
        report.column('project_id').is_visible = false
     end 
     yield public_report if block_given?       
     return public_report
     
   end
   def self.internal_report_list( &block) 
     public_report = internal_report("Internal Reports",Report) do | report |
        report.column('name').customize(        :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description').customize( :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('base_model').customize(  :order_num=>3,:label=>:model,:is_filterible=>true,:is_visible=>true)
        report.column('style').customize(       :order_num=>5,:label=>:style,:filter=>'System',:is_visible=>false)
     end 
     yield public_report if block_given?       
     return public_report
     
   end
    
    def self.assay_list( &block) 
     assay_report = internal_report("Project Assays",Assay) do | report |
        report.column('name').customize(          :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description').customize(   :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('project.name').customize(  :order_num=>3,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('project_element.state.name').customize(:order_num=>4,:label=>:state,:is_filterible=>true,:is_visible=>true)
        report.column('started_at').customize(    :order_num=>5,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at').customize(   :order_num=>6,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project_id').is_visible = false
     end 
     yield assay_report if block_given?        
     return assay_report
   end

    def self.experiment_list( &block) 
     experiment_report = internal_report("Project Experiments",Experiment) do | report |
        report.column('name').customize(        :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description').customize( :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('project.name').customize(:order_num=>3,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('process.name').customize(:order_num=>4,:label=>:process,:is_filterible=>true,:is_visible=>true)
        report.column('project_element.state.name').customize(:order_num=>5,:label=>:state,:is_filterible=>true,:is_visible=>true)
        report.column('started_at').customize(  :order_num=>6,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at').customize( :order_num=>7,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('status_summary').customize(:order_num=>8,:is_visible => true,:label=>'summary')
        report.column('project_id').is_visible = false
     end 
     yield experiment_report if block_given?        
     return experiment_report
   end
    
    def self.task_list( &block) 
     task_report = internal_report("Project Tasks",Task) do | report |
        report.column('name').customize(          :order_num=>1,:is_filterible=>true,:is_visible=>true)
        report.column('description').customize(   :order_num=>2,:is_filterible=>true,:is_visible=>true)
        report.column('project.name').customize(  :order_num=>3,:label=>:project,:is_filterible=>true,:is_visible=>true)
        report.column('experiment.name').customize(:order_num=>4,:label=>:experiment,:is_filterible=>true,:is_visible=>true)
        report.column('process.name').customize(  :order_num=>5,:label=>:process,:is_filterible=>true,:is_visible=>true)
        report.column('project_element.state.name').customize(:order_num=>6,:label=>:state,:is_filterible=>true,:is_visible=>true)
        report.column('started_at').customize(    :order_num=>7,:label=>:started,:is_filterible=>true,:is_visible=>true)
        report.column('expected_at').customize(   :order_num=>8,:label=>:expected,:is_filterible=>true,:is_visible=>true)
        report.column('project_id').is_visible = false
     end 
     yield task_report if block_given?  
     return task_report
   end
    
  def self.internal_report( name, model, &block)
    name ||= "Biorails::List #{model}"
    Report.transaction do
      report = Report.find(:first,:conditions=>['name=? and base_model=?',name.to_s, model.to_s])
      if report.nil?
          ActiveRecord::Base.logger.info " Generating default report #{name} for model #{model}"
          report = Report.new
          report.name = name 
          report.description = "Default reports for display as /#{model.to_s}/list"
          report.model= model
          report.internal=true
          report.style ='System'
          report.save
          for col in model.content_columns
            report.column(col.name)
         end          
          report.column('id').is_visible = false
          if report.has_column?('name')
             report.column('name').is_filterible = true
          end
          yield report if block_given?   
          report.save!
      else
          ActiveRecord::Base.logger.info " Using current report #{name} for model #{model.class_name}"             
      end #built report
      return report
    end # commit transaction
  end    
    
 end
end
