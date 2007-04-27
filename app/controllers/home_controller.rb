class HomeController < ApplicationController

  use_authorization :home,
                    :actions => [:index,:show,:projects,:calendar,:timeline,:blog,:destroy],
                    :rights => :current_user  


  def index
    show
  end

  def show
    @user = current_user    
    respond_to do | format |
      format.html { render :action => 'show'}
      format.xml {render :xml =>  @user.to_xml(:include=>[:projects,:tasks,:requested_services,:queue_items])}
    end
  end

  def projects
    @user = current_user    
    respond_to do | format |
      format.html { render :action => 'projects'}
      format.xml  { render :xml =>  @user.to_xml(:include=>[:projects])}
    end
  end


  def calendar
    @master = current_user
    @calendar = Schedule.new(Task)
    @calendar.calendar(params)
    render :layout => false if request.xhr?
  end

##
#
  def timeline
    @master = current_user
    @gnatt = Schedule.new(Task)
    @gnatt.gnatt(params)
    render :layout => false if request.xhr?
  end

##
# List of list 20 pieces of information added by the user
#
  def blog
    @user = current_user
    @elements = ProjectElement.find(:conditions=>["created_by = ? or updated_by = ?",@user.id,@user.id],
                                    :order=>'updated_by,created_by',:limit=>20 )
    render :layout => false if request.xhr?
  end  
  
        
protected 
  def context
    @user = current(user,params[:id])     
  end
    
end
