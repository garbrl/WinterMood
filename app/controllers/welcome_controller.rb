
class WelcomeController < ApplicationController

=begin
  Description: pre-view control method for view 'welcome/index'
=end
  def index
  end

=begin
  Description: pre-view control method for view 'welcome/login'.
               if the user is already logged in, redirects to
               index

=end
  def login
    if (logged_in?)
      redirect_to("/welcome/index")
    end
  end


=begin
  Description: method for post-verb HTTP requests to create
               a new session.
=end
  def create_new_session
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log in
      log_in(user)
      redirect_to("/welcome/index")
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render("login")
    end
  end

=begin
  Description: method for post-verb HTML requests to destroy
               the currently active session
=end
  def destroy_session
  	log_out()
  	redirect_to(root_url)
  end


=begin
  Description: pre-view control method for view 'welcome/user_listing'.
               if the user is not the administrator of the username 'john cena'
               then the user will be redirected with a HTTP403 status error
=end
  def user_listing
    user = current_user;

    if (user == nil || user.username != "john cena")
      render_error(403)
    else
  		@users = User.all
    end

  end

=begin
  Description: pre-view control method for view 'welcome/registration'.
=end
  def registration
    @user = User.new
  end

=begin
  Description: method for post-verb HTML requests to create a new
               user credential set.
=end
  def create_new_user
		@user = User.new(params.require(:user).permit(:username, :password))

    @user.lastEntryTime = 0 # 1970 January 1st 00:00:00
    @user.defaultCity = "Vancouver"
    @user.defaultSleep = 480
    @user.defaultExercise = 30

		if @user.save
			log_in(@user)
	  	redirect_to("/welcome/index")
		else
		  render 'registration'
		end
  end

=begin
  Description: pre-view control method for view 'welcome/view'.
               if the user is not the administrator of the username
               'john cena', and the user is attempting to access
               a page which is not assigned to them then the user
               will be redirected with HTT403 status error.
=end
  def show
    user = current_user;

    if (!is_integer(params[:id]))
      render_error(404)
    elsif (
      user == nil ||
      (user.id != params[:id].to_i && user.username != "john cena")
      )
      render_error(403)
    else
      @user = User.find(params[:id])
      @ext = User.find(params[:id])
      @moods = Mood.select("*").where(:userid => Integer(params[:id]))

    end

  end

end
