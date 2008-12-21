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
                    :use => [:list,:show,:new,:create,:edit,:update,:destroy]

  def index
    list
    render :action => 'list'
  end

  def list
    @assay = Assay.load(params[:id])
    @report = Biorails::ReportLibrary.parameter_list("ParameterList")
  end
  
  def show
    @parameter = Parameter.find(params[:id])
  end


  
end
