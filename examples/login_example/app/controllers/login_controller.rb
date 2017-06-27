class LoginController < ApplicationController

  def index
    
  end

  # POST only
  def requestlogin

    username = params[:username]
    password = params[:password]

    if (User::user_credentials_valid?(username, password))
    
      session_key = Session::create_new_session(username, password)
      cookies[:session_key] = session_key
      cookies[:username]    = username
      
      redirect_to(
          controller: "login",
          action: "index"
        )
      
    else
      
      redirect_to(
          controller: "login",
          action: "index",
          message: "Username or password is not valid"
        )
      
    end

  end
  
  # POST only
  def getnewlogin
    
    username = params[:username]
    password = params[:password]
    
    if (User::user_exists?(username))
      redirect_to(
          controller: "login", 
          action: "index",
          message: "User already exists"
        )
    else
      
      User::user_create(username, password)
      session_key = Session::create_new_session(username, password)
      cookies[:session_key] = session_key
      cookies[:username]    = username
      
      redirect_to(
          controller: "login",
          action: "index"
        )
      
    end
    
  end
  
  # POST only
  def releaselogin
    
    session_key = cookies[:session_key]
    username = cookies[:username]
    
    if (defined?(session_key) && defined?(username))
      Session::remove_session(username)
    end
    
    cookies.delete(:session_key)
    cookies.delete(:username)
    
    redirect_to(
        controller: "login",
        action: "index",
        message: "You've logged out successfully"
      )
    
  end

end
