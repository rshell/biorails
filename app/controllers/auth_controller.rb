class AuthController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :login ],
         :redirect_to => { :action => :logout }

  def login
    if request.get?
      AuthController.clear_session(session)
    else
      user = User.find_by_name(params[:login][:name])
      
      if user and user.check_password(params[:login][:password])
        logger.info "User #{params[:login][:name]} successfully logged in"
        session[:user_id] = user.id
        role = Role.find(user.role_id || 1)
        session[:role_id] = role.id
        session[:username] = params[:login][:name]
        session[:credentials] = role.credentials
        session[:menu] = role.menu
        
        respond_to do |wants|
          wants.html do
            redirect_to "/"
          end
          wants.xml do
            render :nothing => true, :status => 200
          end
        end
        
      else
        logger.warn "Failed login attempt"
        respond_to do |wants|
            wants.html do
              redirect_to :action => 'login_failed'
            end
            wants.xml do
              render :nothing => true, :status => 404
            end
          end
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
    AuthController.logout(session)
    redirect_to "/"
  end


  def self.authorised?(credentials, params)
    authorised = false  # default
    check_controller = false

    if params[:controller] == 'content_pages' and  params[:action] == 'view'
      if credentials.pages.has_key?(params[:page_name].to_s)
        if credentials.pages[params[:page_name].to_s] == true
          logger.info "Page: authorised"
          authorised = true
        else
          logger.info "Page: NOT authorised"
        end
      else
        logger.warn "(Unknown page? #{params[:page_name].to_s})"
      end
    else
      # Check if there's a specific permission for an action
      if credentials.actions.has_key?(params[:controller])
        if credentials.actions[params[:controller]].has_key?(params[:action])
          if credentials.actions[params[:controller]][params[:action]]
            logger.info "Action: authorised"
            authorised = true
          else
            logger.info "Action: NOT authorised"
          end
        else
          check_controller = true
        end
      else
        check_controller = true
      end
      
      # Check if there's a general permission for a controller
      if check_controller
        if credentials.controllers.has_key?(params[:controller])
          if credentials.controllers[params[:controller]]
            logger.info "Controller: authorised"
            authorised = true
          else
            logger.info "Controller: NOT authorised"
          end
        else
          end
      end
    end  # Check permissions
    
    logger.info "Authorised? #{authorised.to_s}"
    return authorised
  end


  protected

  def self.logout(session)
    session.delete
    self.clear_session(session)
  end

  def self.clear_session(session)
    session[:user_id] = nil
    session[:user] = nil
    session[:credentials] = nil
    session[:menu] = nil
    session[:clear] = true
  end

end
