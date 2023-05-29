# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def respond_with(resource, options={})
    if resource.persisted?
      token = JWT.encode({user_id: resource.id}, Rails.application.secrets.secret_key_base)
      render json: {
        status: { code: 200, message: 'signed up successfully', data: resource }
      }, status: :ok
    else
      render json: {
        status: { message: 'unprocessable_entity' }
        
      },status: :unprocessable_entity
    end
  end


  # def create
  #   build_resource(sign_up_params)
    
  #   if resource.save
  #     sign_in(resource)
  #     token = JWT.encode({ user_id: resource.id }, Rails.application.secrets.secret_key_base)
      
  #     render json: {
  #       status: { code: 200, message: 'Signed up successfully', data: resource, token: token }
  #     }, status: :ok
  #   else
  #     render json: {
  #       status: { message: 'User could not be created successfully', errors: resource.errors.full_messages },
  #       status: :unprocessable_entity
  #     }
  #   end
  # end

  # def sign_up_params
  #   params.permit(:email, :password)
  # end

end
