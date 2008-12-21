# == Assay Parameters Controller
# This is used manage the parameters name space for a assay definition. In a 
# assay a list of pre customized parameter templates are defined here.
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class Organize::AssayParametersController < ApplicationController
  use_authorization :organization,
                    :use => [:list,:show,:new,:create,:edit,:update,:destroy]

  before_filter :setup_assay , :only => [:index, :list,:new,:refresh,:create,:export,:import, :import_file]
  
  before_filter :setup_assay_parameter , :only => [ :show, :edit, :update,:destroy,:protocol_list,:process_metrics,:experiment_metrics]
                    
  def index
    list
  end

  def list    
    respond_to do | format |
      format.html { render :action => 'list'}
      format.xml  { render :xml =>  @assay.to_xml}
    end    
  end
#
# show the details of a current parameter with usage statisticsts etc
#
  def show
    respond_to do | format |
      format.html { render :action => 'show'}
      format.xml  { render :xml =>  @assay_parameter.to_xml}
    end    
  end

##
# Generate a report on protocol using this parameter type
#
 def protocol_list
   @report = Biorails::ReportLibrary.parameter_list("Parameter usage for #{@assay_parameter.name}") do | report|
      report.column('assay_parameter_id').filter = "#{@assay_parameter.id}"
   end
   @report.save

    respond_to do | format |
      format.html { render :action => 'report' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.pdf  { render_pdf :action => 'report',:layout=>false }
      format.json { render :json => @report.data.to_json }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end


##
# Generate a report on protocol level statistics filter down to only this parameter type
#
  def process_metrics
    @report = Biorails::ReportLibrary.process_statistics("Process Stats #{@assay_parameter.name}") do | report|
      report.column('assay_parameter_id').filter = "#{@assay_parameter.id}"
    end
    @report.save
    respond_to do | format |
      format.html { render :action => 'report' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.pdf  { render_pdf :action => 'report',:layout=>false }
      format.json { render :json => @report.data.to_json }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end

##
# Generate a report on experiment level statistics filter down to only this parameter type
#
  def experiment_metrics
   @report = Biorails::ReportLibrary.experiment_statistics("Experiment Stats #{@assay_parameter.name}") do | report|
    report.column('assay_parameter_id').filter = "#{@assay_parameter.id}"
   end
   @report.save
    respond_to do | format |
      format.html { render :action => 'report' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.pdf  { render_pdf :action => 'report',:layout=>false }
      format.json { render :json => @report.data.to_json }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end

#
# Create a new assay Parameter
#
  def new
    @assay_parameter = AssayParameter.new(:assay=>@assay)
    @assay_parameters = @assay.parameters.find(:all,:limit=>3,:order=>'assay_parameters.id desc')    
    respond_to do | format |
      format.html { render :action => 'new'}
      format.xml  { render :xml =>  @assay_parameter.to_xml}
    end    
  end
  
#
# create a new assay parameter 
#
  def create
    @assay_parameter = AssayParameter.new(params[:assay_parameter])
    @parameter_type = @assay_parameter.type
    @assay.parameters << @assay_parameter
    if @assay_parameter.save
      flash[:notice] = "Parameter #{@assay_parameter.name} successfully added"
      redirect_to :action => 'new', :id => @assay.id
    else
      @assay_parameters = @assay.parameters.find(:all,:limit=>3,:order=>'assay_parameters.id desc')    
      @type = DataType.find(1)
      render :action => 'new', :id => @assay.id
    end
  end

  def edit
    @type = @assay_parameter.data_type
  end

  def update
    if @assay_parameter.update_attributes(params[:assay_parameter])
      flash[:notice] = 'AssayParameter was successfully updated.'
      redirect_to :action => 'list', :id => @assay_parameter.assay.id
    else
      @type = @assay_parameter.data_type
      render :action => 'edit'
    end
  end

  def destroy
    if @assay_parameter.used?
      flash[:warning] ="Parameter #{@assay_parameter.name} is still in use so can not be deleted"
    else
    @assay_parameter.destroy
    end
    redirect_to :action => 'list',:id => @assay.id
  end
  
#
#  export Report of Concepts as CVS
#  
  def export
    report = @assay.export_parameters
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => @assay.name+"-"+'parameter.csv')
  end   

  
#
# Create a Tree data model
#
  def tree
    @assay = Assay.find(params[:id])        
	if params[:node] == 'root'
      return render( :inline => "<%= parameter_roles_to_json(@assay.allowed_roles) %>")

	elsif params[:node] == 'queue'
      return render( :inline => "<%= assay_queues_to_json(@assay.queues) %>")

    else        
      return render( :inline => "<%= assay_parameters_to_json( @assay.parameters_for_role( params[:node] ) ) %>")
    end
  end
 
  
  def import
  end

##
# Import Parameter from CVS file using the first row as titles
# 
  def import_file
   @warnings = @assay.import_parameters(params[:file],params[:types],params[:roles])
   if @warnings.size>0
     flash[:warning] = @warnings.join("<br />")
   else
     flash[:info] ="Imported parameters successfully"
   end
   redirect_to :action => 'list', :id => @assay.id
  end

  
##
# Refresh the data format fields on the Parameter dialog form
# AJAX handler for dropdown of data type field
#   
  def refresh    
    @assay_parameter = AssayParameter.new
    @assay_parameter.assay =  @assay
    if params[:parameter_type_id].blank?

    else
      @parameter_type = ParameterType.find(params[:parameter_type_id])
      @assay_parameter.type =  @parameter_type
      @parameter_type_alias = @parameter_type.aliases.find_by_name(params[:alias]) if params[:alias]
      @parameter_type_alias ||= @parameter_type.aliases[0]      
      @assay_parameter.use_template(@parameter_type_alias) if @parameter_type_alias
    end
    respond_to do | format |
      format.html { render :action => 'new'}
      format.xml  { render :xml =>  @assay_parameter.to_xml}
      format.js   { 
        render :update do | page |
           page.replace_html 'form_alias',   :partial => 'form_alias'
           page.replace_html 'form_description', :partial => 'form_description'
           page.replace_html 'form_config',  :partial => 'form_config'
           page.replace_html 'form_rules',   :partial => 'form_rules'
           page.replace_html 'form_buttons', :partial => 'form_buttons'
           page.replace_html 'messages',     :partial => 'shared/messages',:locals => { :objects => ['assay','assay_parameter' ]} 
         end
       }
    end        
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
   begin
      @successful = false 
      @assay_parameter = AssayParameter.find(params[:id])
      field_domid = params[:element]
      result_domid = "result_#{@assay_parameter.id}"
      @assay = @assay_parameter.assay
      @assay_parameters = @assay.parameters
      @value =  @assay_parameter.parse(params[:value])
      @successful = !@value.nil?
      @text =   @assay_parameter.format(@value)
   rescue Exception => ex
      logger.error "current error: #{ex.message}"
      logger.error ex.backtrace.join("\n")
      @successful = false
   end  
    respond_to do | format |
      format.html { render :action => 'list'}
      format.xml  { render :xml =>  @assay_parameter.to_xml}
      format.js   {
       render :update do | page |
          if  @successful
            page[field_domid].value = @text
            case @value
            when Unit
              page.replace_html result_domid, "#{@text} [#{@value.to_base}]"
            when ActiveRecord::Base
              page.replace_html result_domid, "#{@text} [#{@value.class}##{@value.id}]"
            else
              page.replace_html result_domid, "#{@text}"
            end
            page.visual_effect :highlight, field_domid, {:endcolor=>'#99FF99',:restorecolor=>'#99FF99'}
          else
            page.visual_effect :highlight, field_domid, {:endcolor=>'#FFAAAA',:restorecolor=>'#FFAAAA'}
          end        
       end
      }
    end
  end  
  
 
protected  
  
  def setup_assay
    @assay = Assay.load(params[:id])  
    @assay ||= current_project.assay(params[:id])  
    return show_access_denied unless @assay
    @assay_parameters = @assay.parameters
    @parameter_types = ParameterType.select_list
    set_project(@assay.project)
    set_element(@assay.folder)
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end

  def setup_assay_parameter    
    @assay_parameter = AssayParameter.load(params[:id])
    @parameter_type =@assay_parameter.type
    return show_access_denied  unless @assay_parameter
    @assay = @assay_parameter.assay
    set_project(@assay.project)
    set_element(@assay_parameter.folder)
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end



end

