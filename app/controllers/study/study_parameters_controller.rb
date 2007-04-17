##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
 require 'csv'
 
class Study::StudyParametersController < ApplicationController
  use_authorization :study,
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
    @study = Study.find(params[:id])    
  end

  def show
    @study_parameter = StudyParameter.find(params[:id])
    @study =@study_parameter.study
    protocol_list
    protocol_metrics
    experiment_metrics
  end

  def new
    @study = Study.find(params[:id])    
    @study_parameter = StudyParameter.new
    @study_parameter.study =  @study
    #@study_parameter.type = ParameterType.find(:first)
  end

  def create
    @study = Study.find(params[:id])    
    @study_parameter = StudyParameter.new(params[:study_parameter])
    @study.parameters << @study_parameter
    if @study_parameter.save
      flash[:notice] = 'StudyParameter was successfully created.'
      redirect_to :action => 'list', :id => @study.id
    else
      @type = DataType.find(1)
      render :action => 'new', :id => @study.id
    end
  end

  def edit
    @study_parameter = StudyParameter.find(params[:id])
    @study =@study_parameter.study
    @type = @study_parameter.data_type
  end

  def update
    @study_parameter = StudyParameter.find(params[:id])
    @study =@study_parameter.study
    if @study_parameter.update_attributes(params[:study_parameter])
      flash[:notice] = 'StudyParameter was successfully updated.'
      redirect_to :action => 'list', :id => @study_parameter.study.id
    else
      @type = @study_parameter.data_type
      render :action => 'edit'
    end
  end

  def destroy
    @study_parameter = StudyParameter.find(params[:id])
    @study = @study_parameter.study
    @study_parameter.destroy
      render :action => 'list',:id => @study.id
  end
  
#
#  export Report of Concepts as CVS
#  
  def export
    @study = Study.find(params[:id])    
    items = @study.parameters
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
      csv << %w(parameter_id parameter_name role_id role_name name value type_id type_name format_id format_name )
      items.each do |item|
        line = [item.type.id,      item.type.name,
                item.role.id,      item.role.name,
                item.name, item.default_value]                
        line << item.data_type.id 
        line << item.data_type.name
        if item.data_type_id=5 and item.data_element
          line << item.data_element.id 
          line << item.data_element.name         
        elsif item.data_format 
          line << item.data_format.id 
          line << item.data_format.name 
        end
        csv << line
      end  
    end

    report.rewind
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => @study.name+"-"+'parameter.csv')
  end   

  def import
    @study = Study.find(params[:id])    
  end

##
# Import Parameter from CVS file using the first row as titles
# 
  def import_file
     flash[:warning] = nil
     flash[:error] = nil
     @study = Study.find(params[:id])    
     reader = CSV::Reader.create(params[:file]) 
     header = reader.shift
     lookup = Hash.new
     0.upto(header.size-1) do |col|     
        lookup[header[col]]=col
     end
     reader.each do |row|
       @study_parameter = StudyParameter.new({:name => row[lookup['name']],:default_value => row[lookup['value']]  })
       begin
         @study_parameter.description = "#{lookup['name']} based on #{lookup['parameter_name']} with role #{lookup['role_name']}"
         @study_parameter.type = locate(ParameterType, row[lookup['parameter_name']], 
                                                       row[lookup['parameter_id']] , params[:types]) 
                                         
         @study_parameter.role = locate(ParameterRole, row[lookup['role_name']], 
                                                       row[lookup['role_id']] , params[:roles]) 
                                         
         @study_parameter.data_type = locate(DataType, row[lookup['type_name']] , 
                                                       row[lookup['type_id']] ,false)
         
         if 5 == @study_parameter.data_type_id
            @study_parameter.data_element = locate(DataElement, row[lookup['format_name']] ,
                                                                row[lookup['format_id']] , false)
         
         else
            @study_parameter.data_format = locate(DataFormat, row[lookup['format_name']] ,
                                                              row[lookup['format_id']] , false)
         end                                                
         @study_parameter.name = row[lookup['name']] 
         @study_parameter.study = @study
  
         if @study_parameter.save
          logger.info "Added Study Parameter #{@study_parameter.name}  to #{@study.name}" 
         else
          logger.info "Failed to add Study Parameter #{@study_parameter.name}  to #{@study.name}" 
          flash[:warning] = " #{flash[:warning]} <br/> Cant import row: "+row.join(",") 
          flash[:warning] += "<br> <ul><li> #{@study_parameter.errors.full_messages().uniq.join('</li><li>')}</ul>"
         end
        rescue 
          flash[:error] = "#{flash[:warning]} <br/> Error with row: "+row.join(",")
          logger.warn "failed to import "+row.join(",")+"\n "+$!.to_s+"\n"
          logger.debug "error record " + @study_parameter.to_yaml
        end 
     end     
   redirect_to :action => 'list', :id => @study.id
  end

###
# Helper function to locate match records for foreign key references
# 
  def locate(model, name, id = nil,create = false)
    object = nil
    logger.info("locate("+model.to_s+","+name+","+id.to_s+")")
    if name
      if id 
        object = model.find(id.to_i) 
        if object.name != name
           object = nil
        end
      else
        object = model.find_by_name(name)
      end
      if !object and create
         object = model.new({:name => name,:description => 'import generated '+name})
      end
    end 
    logger.info("Found "+object.name)
    return object 
  end
##
# Refresh the data format fields on the Parameter dialog form
# AJAX handler for dropdown of parameter type field
#   
  def refresh_type
    if params[:id]
      @study_parameter = StudyParameter.find(params[:id])
    else
      @study_parameter = StudyParameter.new
    end
    text = request.raw_post || request.query_string
    parameter_type_id = text.split('=')[1]
    @study_parameter.type = ParameterType.find(parameter_type_id)
    return render(:action => 'type_changed.rjs') if request.xhr?
    render :partial => "data_type" 
  end
  
##
# Refresh the data format fields on the Parameter dialog form
# AJAX handler for dropdown of data type field
#   
  def refresh_formats
    if params[:id]
      @study_parameter = StudyParameter.find(params[:id])
    else
      @study_parameter = StudyParameter.new
    end
    @study_parameter.type = ParameterType.find(params[:parameter_type_id])
    text = request.raw_post || request.query_string
    data_type_id = text.split('=')[1]
    @study_parameter.data_type = DataType.find(data_type_id)
    return render(:action => 'format_changed.rjs') if request.xhr?
    render :partial => "formats" 
  end

##
# Handle cell change events to save data back to the database
# 
# param[:id] = task
# param[:row]= row_no (test_context.row_no)
# param[:col]= column_no for parameter
# param[:cell]= dom_id for the cell changes
# 
# content of message is the data for the value
# 
  def test_save
    @successful = false 
    parameter = StudyParameter.find(params[:id])
    @element = "cell_#{params[:element].split('_')[1]}_3"
    text = request.raw_post || request.query_string
    @value = text.split("=")[1]        

    return render(:action => 'test_save.rjs') if request.xhr?
    render :action => 'show'
  rescue 
     flash[:error]="Problems with save of cell "+@dom_id
     logger.error "Problem with save"+ $!.to_s
  end  


protected  


##
# Generate a report on protocol using this parameter type
# 
 def protocol_list
   @protocol_report = Report.find_by_name("ParameterProtocols") 
   @protocol_report.column('study_parameter_id').is_visible = false
   unless @protocol_report
      @protocol_report = report_list_for("ParameterProtocols",Parameter)
      @protocol_report.save
   end  
   @protocol_report.column('study_parameter_id').filter = "#{@study_parameter.id}"
   @protocol_data = @protocol_report.run({:limit  =>  32})
  end


##
# Generate a report on protocol level statistics filter down to only this parameter type
# 
  def protocol_metrics
   @metrics_report = Report.find_by_name("ParameterStatistics") 
   @metrics_report.column('study_parameter_id').is_visible = false
   unless @metrics_report
      @metrics_report = report_list_for("ParameterStatistics",ProcessStatistics)
      @metrics_report.save
   end  
   @metrics_report.column('study_parameter_id').filter = "#{@study_parameter.id}"
   @metrics_data = @metrics_report.run({:limit  =>  32})
  end

##
# Generate a report on experiment level statistics filter down to only this parameter type
# 
  def experiment_metrics
   @experiment_report = Report.find_by_name("ExperimentStatistics") 
   @experiment_report.column('study_parameter_id').is_visible = false
   unless @experiment_report
      @experiment_report = report_list_for("ExperimentStatistics",ExperimentStatistics)
      @experiment_report.save
   end  
   @experiment_report.column('study_parameter_id').filter = "#{@study_parameter.id}"
   
   @experiment_data = @experiment_report.run({:limit  =>  32})
  end
  
end

