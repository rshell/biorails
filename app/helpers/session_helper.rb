module SessionHelper

  def logged_in?
    !session[:user_id].nil?
  end

  def admin?
      logged_in? && current_user.admin?
  end

##
# Output username or You for own records
# 
  def who(name)
    return current_user.login == name ? "You" : name
  end
   
  # check if login is globally required to access the application
  def authorized
    login unless loggged_in?
  end 


##
# Reference to the current User
#       
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user ||= User.find(:first) # Guest 
    end
  end
  

##
# Set the Current user
# 
  def current_user=(user)
      @current_user = user
      if user  
        session[:user_id] = user.id    
      else
         session[:user_id] = nil
      end      
  end

##
# Reference to the current project
# 1st checks for a pass parameter of project_id
# 2nd checks for a session project_id
# 3rd find the object
#   
  def current_project
   logger.info("current_project params:#{params[:project_id]} session:#{session[:project_id]} ")
   id ||= params[:project_id] 
   id ||= session[:project_id]
   unless  @project and @project.id == id
       logger.info("Changing Project #{id} ")
       @project = current(Project,id)
       session[:project_id] = @project.id
   end
   return @project
  end
  

##
# Get the lastest object of this type in the system
  def lastest(clazz)
      return clazz.find(:first, :order => 'updated_at desc')
  rescue Exception => ex
      logger.error "lastest(#{clazz}) error: #{ex.message}"
      return clazz.new
  end 

##
# Get current version of this model passed on param[:id] and
# if not found the current session
#
  def current(model,id=nil)
    key = "#{model.to_s}_id"
    logger.debug "current(#{model},#{id})"
    if !id.nil?
        instance = model.find(id)
    elsif instance.nil? && session[key]
        instance = model.find(session[key])
    else
        instance = lastest(model)
    end
    session[:controller]=key.downcase.tableize
    session[key]= instance.id
    return instance
  rescue Exception => ex
      logger.error "current error: #{ex.message}"
      return lastest(model)
  end
   
###
# Display a Hit list last search user performanced 
# This uses the session[:hits] as a cache of hits
# 
  def hitlist
     @hits = session[:hits] 
     render :partial => 'shared/hitlist', :layout => false      
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
       "Err. (no hitlist)"
  end

###
# Display a Hit list last search user performanced 
# This uses the session[:hits] as a cache of hits
# 
  def hitlist
     @hits = session[:hits] 
     render :partial => 'shared/hitlist', :layout => false      
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
       "Err. (no hitlist)"
  end

end

