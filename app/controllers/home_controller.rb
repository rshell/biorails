class HomeController < ApplicationController

  def index
    respond_to do | format |
      format.html
      format.xml
    end
  end

  def todo
    
  end

  def calender
    @user = current_user
    @calender = Schedule.calendar(Task,@params)
    @calender.find_by_user(@user.id)
    render :layout => false if request.xhr?
  end


  def timeline
    @user = current_user
    @calender = Schedule.gnatt(Task,@params)
    @calender.find_by_user(@user.id)
    render :layout => false if request.xhr?
  end

  def blog
  end  

protected 
  def context
    @user = current(user,params[:id])     
  end
    
end
