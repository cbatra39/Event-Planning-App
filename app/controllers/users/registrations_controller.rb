class Users::RegistrationsController < Devise::RegistrationsController
  include Responses
  skip_before_action :verify_authenticity_token
  respond_to :json

  def respond_with(resource, options={})
    if resource.persisted?
      token = JWT.encode({ user_id: resource.id }, Rails.application.secrets.secret_key_base)
      resource.send_confirmation_instructions

      success('A mail has sent to your email, please verify your account')
    else
      error('unprocessable_entity')
    end
  end

  def sign_up_params
    params.permit(:email, :password)
  end

end
