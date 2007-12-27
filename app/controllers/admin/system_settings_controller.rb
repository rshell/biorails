class Admin::SystemSettingsController < ApplicationController
  use_authorization :catalogue,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @system_settings = SystemSetting.find(:all)
  end

  def edit
    @system_setting = SystemSetting.find(params[:id])
  end

  def update
    @system_setting = SystemSetting.find(params[:id])
    if @system_setting.update_attributes(params[:system_setting])
      flash[:notice] = 'SystemSettings was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  protected

  def foreign
    @roles = Role.find(:all, :order => 'name')
    
  end

end
