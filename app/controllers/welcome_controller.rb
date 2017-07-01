class WelcomeController < ApplicationController

  def index
  end

  # Formerly in Session

  def login
  end

  def create_new_session
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log in
      log_in(user)
      redirect_to("/welcome/user_listing")
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render("login")
    end
  end

  def destroy_session
  	log_out()
  	redirect_to(root_url)
  end



  # Formerly in User

  def user_listing
		@users = User.all
  end

  def registration
    @user = User.new
  end

  def create_new_user
		@user = User.new(params.require(:user).permit(:username, :password))

		if @user.save
			log_in(@user)
	  	redirect_to("/welcome/#{@user.id}")
		else
		  render 'registration'
		end
  end

  def show
		@user = User.find(params[:id])
  end

end
