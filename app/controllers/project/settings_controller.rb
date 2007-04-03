class Project::SettingsController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

  def update
    if site.update_attributes params[:site]
      redirect_to :action => 'index'
    else
      render :action => 'index'
    end
  end
  
  protected
    alias authorized? admin?
end
