class AuthController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)

  def login
    clear_session
    if request.get?
      render :action=>'login'
    else
      user = User.authenticate(params[:login],params[:password])
      if user
        logger.info "User #{params[:login][:name]} successfully logged in"
        set_user(user)
        set_project(user.projects[0])
        redirect_to home_url(:action=>'show')
      else
        login_failed
      end
    end
  end  # def login
  
  def forgotten
  end

  def login_failed
    flash.now[:error] = "Incorrect Name/Password"
    render :action => 'forgotten'
  end

  def logout
    puts "logout #{session[:user_id]}"
    clear_session
    redirect_to auth_url(:action=>'login')
  end

  def access_denied
    logger.error "User access denied"
  end
end
