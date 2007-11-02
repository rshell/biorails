class AuthController < ApplicationController


# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)

  def login
    clear_session
    if request.get?
      render :action=>'login',:layout=> 'simple'
    else
      user = User.authenticate(params[:login],params[:password])
      if user and user.enabled?
        logger.info "User #{params[:login][:name]} successfully logged in"
        set_user(user)
        set_project(user.projects[0])
        if session[:current_url]
          redirect_to session[:current_url]
        else
          redirect_to home_url(:action=>'show')          
        end
      else
        login_failed
      end
    end
  end  # def login
  
  def forgotten  
    logger.warn("TODO setup SMTP mail and send new password for "+params[:mail])    
    redirect_to :action=>'login'
  end

  def login_failed
    flash.now[:error] = "Incorrect Name/Password"
    render :action => 'forgotten',:layout=> 'simple'
  end

  def logout
    logger.info "logout #{session[:user_id]}"
    clear_session
    render :action=>'login',:layout=> 'simple'
  end

  def access_denied
    logger.error "User access denied"
  end
end
