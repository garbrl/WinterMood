module ApplicationHelper
=begin
 Description: Returns the current user object

 parameters:
   none

=end
 def current_user
   return @current_user ||= User.find_by(id: session[:user_id])
 end

=begin
 Description: Returns 'true' if a user-session is
              open, and 'false' otherwise

 parameters:
   none

=end
 def logged_in?
   return !current_user.nil?
 end


=begin
  Description: Renders the specified error

  parameters:
    code (int)   the HTTP error code to render
=end
  def render_error(code)
    render(:file => File.join(Rails.root, "/public/errors/#{code}.html"), :status => code)
  end


end
