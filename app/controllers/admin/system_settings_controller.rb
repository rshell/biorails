##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class Admin::SystemSettingsController < ApplicationController
  
  use_authorization :dba,
                    :actions => [:list,:edit,:update],
                    :rights => :current_user
  def index
    list
    render :action => 'list'
  end

  def list
    @system_settings =[]
    SystemSetting.all.each do |setting|
      if setting.value.nil? || setting.value.to_s.empty?
        setting.value="?"
      end
      @system_settings << setting
    end
  end
  
  def update
    name=params[:id]
    item = SystemSetting.get(name)
    return render(:text=>"#invalid name") unless item
    begin
      item.value=params[name]   
      item.save!
      return render(:text=>item.displayed_value)
    rescue Exception
       logger.info "failed to set value SystemSetting #{params[:id]}   "
      render(:text=> item.displayed_value)
    end
  end
  
end
