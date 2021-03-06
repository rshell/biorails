# ##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
class Admin::DataElementsController < ApplicationController

  use_authorization :catalogue,
    :use => [:choice,:select,:list,:show],
    :admin => [:new,:add,:create,:destroy,:export,:index]

  in_place_edit_for :data_element, :name
  in_place_edit_for :data_element, :description  
  # 
  # default action is list
  # 
  def index
    data_system = DataSystem.find(:first)
    redirect_to :controller=>'data_systems',:action => 'show', :id => data_system
  end

  # 
  # List all the data_elements
  # 
  def list
    data_system = DataSystem.find(:first)
    redirect_to :controller=>'data_systems',:action => 'show', :id => data_system
  end
  # 
  # show a selected DataElement by Id
  # 
  def show
    @data_element =DataElement.find( params[:id] )
    @test = DataElement.new
  end

  # ## Autocomplete for a data element lookup return a list of matching records.
  # This is simple helper for lots of forms which want drop down lists of items
  # controller from the central catalog.
  # 
  #  * url is in the form /data_element/choices/n with value=xxxx parameter
  # 
  def choices
    model = ModelExtras.model_from_name( params[:id])
    value   = "#{params[:query]}%"
    if model.respond_to?(:like)
        source = model.like(value)
    elsif model.respond_to?(:list)
        source = model.list(:all,:conditions=>['name like ?',value],:limit=>20,:order=>:name)
    end
    source ||= model.find(:all,:conditions=>['name like ?',value],:limit=>20,:order=>:name)

    @choices =[{:id=>nil,:name =>"",:description=>"Please Select a Item"}]
    if source[0].respond_to?(:path)
      source.each { |item| @choices << {:name=>"#{item.name} (#{item.path})",:id=>item.id}}
    else
      source.each { |item| @choices << {:name=>item.name,:id=>item.id}}
    end

    @list = {:element_id=>params[:id],
      :matches=>@value,
      :total=>@choices.size ,
      :items =>@choices}
    render :text => @list.to_json
  end  

  def select
    element = DataElement.find( params[:id] )
    @value   = params[:query] || ""
    @choices = element.like(@value) || []
    @choices = @choices.collect{|i|{
          :id=>i.id,
          :name=>i.name}}

    @choices = @choices << {:id=>nil,:name =>DataElement::BLANK,:description=>"Please Select a Item"}
    @list = {:element_id=>params[:id],
      :matches=>@value,
      :total=>@choices.size ,
      :items =>@choices}
    render :text => @list.to_json
  end  
  
  # ## Add a Child Data Element
  def add
    @data_element = DataElement.find( params[:id] )
    @child = @data_element.add_child(params[:child][:name] ,params[:child][:description])
    if @child.save
      flash[:notice] = 'Child Data Element was successfully created.'
      redirect_to :action => 'show', :id => @data_element
    else
      flash[:error] = "Child Data Element not valid  as #{@child.errors.full_messages.to_sentence}."
      redirect_to :action => 'show', :id => @data_element
    end
  end
 
  # ## Put up Ajax from for a new Element
  def new
    @data_concept = DataConcept.find(params[:id])    
    @data_element = DataElement.new
    @data_element.style=='list'
    @data_element.concept = @data_concept
    @data_element.name = @data_concept.name
    @data_element.system = DataSystem.find(:first)  
    @data_element.parent = nil
    render( :action => 'new')
  end

  # ## Create a new DataElement for the concept to link in a list of real
  # entities into the catalogue
  # 
  def create
    @data_concept = DataConcept.find(params[:id])
    @data_element = DataElement.create_from_params(params['data_element']) 
    if @data_element.save
      flash[:notice] = 'DataElement was successfully created.'
      return render(:action => 'show.rjs') if request.xhr?
      redirect_to :action => 'list', :id => @data_element.concept
    else
      flash[:warning] = 'DataElement failed  to save.'
      return render( :action => 'new_element')   if request.xhr?
      render( :action => 'new')
    end
  end  

  # 
  # Remove a existing data element from the system
  # 
  def destroy
    @data_element = DataElement.find( params[:id] )
    @data_system = @data_element.system
    @data_element.destroy    
    redirect_to :action => 'list',:id=> @data_system
  end
  
  # 
  #  export Report of Elements as CVS
  # 
  def export
    @items = DataElement.find(:all)
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
      csv << %w(id, context, name, description)
      @items.each do |item|
        csv << [item.id, item.concept.name, item.name, item.description,item.style,item.content]
      end
    end

    report.rewind
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => 'report.csv')
  end  
    
end
