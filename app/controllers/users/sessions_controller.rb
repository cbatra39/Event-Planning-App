# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  private
  def respond_with(resource, options={})
    render json: {
      status: { code: 200, message: "user signed in successfully", data: current_user }
    }, status: :ok
  end 

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
        status: 200,
        message: "signed out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "user has no active session"
      }, status: :unauthorized
    end
  end

  def sign_in_params
    params.permit(:email, :password)
  end
end
