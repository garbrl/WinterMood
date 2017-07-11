
module WelcomeHelper

=begin
	Description: Logs in the user specified
							 by the provided user object

	parameters:
		user,  type: User

=end
	def log_in(user)
		session[:user_id] = user.id
	end

=begin
	Description: Logs out the user by removing any
							 session data associated therin

  parameters:
		none
=end
	def log_out
		session.delete(:user_id)
		@current_user = nil
	end


=begin
	Description: Returns 'true' if the provided
							 string is an integer, 'false'
							 if otherwise
=end
 def is_integer(str)
 	begin
 		Integer(str)
 		return true
 	rescue ArgumentError
 		return false
 	end
 end


end
