

class Users::SessionsController < Devise::SessionsController
  include Responses
  skip_before_action :verify_authenticity_token
  respond_to :json

 

  def respond_with(resource, options={})
    user = User.find_by(email: resource[:email])
    if user && user.status == "active"
      success("User signed in successfully")
    elsif user && user.status == "inactive"
      error("Your account has been disabled")
    else
    error("Invalid email or password")
    end
  end
  

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
        success("signed out successfully")
    else
        error("user has no active session")
    end
  end

end
