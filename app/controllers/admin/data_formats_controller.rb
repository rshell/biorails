# ##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
class Admin::DataFormatsController < ApplicationController
  
  use_authorization :system,
              :admin => [:new,:create,:destroy,:edit,:index,:list,:show,:update]
                     
  def index
    list
    render :action => 'list'
  end

  def list
    @data_type = DataType.find(params[:id]||1)
    @data_formats = DataFormat.paginate(:conditions=>["data_type_id=?",@data_type.id], :page => params[:page])
  end

  def show
    @data_format = DataFormat.find(params[:id])
  end

  def test
    @data_format = DataFormat.find(params[:id])
    @dom_id = params[:element]
    @value = @data_format.parse(params[:value])
    @text = @data_format.format(@value)
    respond_to do | format |
      format.html { redirect_to :action => 'list',:id=> @data_format.data_type_id}
      format.js   {
        render :update do | page |
          if @value 
            page[@dom_id].value = @text
            page.replace_html "result_#{@data_format.id}", "#{@text}"
            page.visual_effect :highlight, @dom_id, {:endcolor=>'#99FF99',:restorecolor=>'#99FF99'}
          else
            page.replace_html "result_#{@data_format.id}","#Invalid"
            page.visual_effect :highlight, @dom_id, {:endcolor=>'#FFAAAA',:restorecolor=>'#FFAAAA'}
          end        
        end
      }
    end
    
  end

  def new
    @data_format = DataFormat.new
  end

  def create
    @data_format = DataFormat.new(params[:data_format])
    if @data_format.save
      flash[:notice] = 'DataFormat was successfully created.'
      redirect_to :action => 'list',:id=> @data_format.data_type_id
    else
      render :action => 'new'
    end
  end

  def edit
    @data_format = DataFormat.find(params[:id])
  end

  def update
    @data_format = DataFormat.find(params[:id])
    if @data_format.update_attributes(params[:data_format])
      flash[:notice] = 'DataFormat was successfully updated.'
      redirect_to :action => 'list',:id=> @data_format.data_type_id
    else
      render :action => 'edit'
    end
  end

  def destroy
    @data_format = DataFormat.find(params[:id])
    @data_type = @data_format.data_type
    @data_format.destroy
    redirect_to :action => 'list',:id=> @data_type.id
  end
end
