module SessionHelper

   
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

