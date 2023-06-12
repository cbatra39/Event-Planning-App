
class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  # def create
  #   self.resource = resource_class.confirm_by_token(params[:confirmation_token])
  #   yield resource if block_given?

  #   if resource.errors.empty?
     
  #     render json: { message: 'Account confirmed successfully.', user: resource }
  #   else
  #     render json: { error: 'Unable to confirm account.' }, status: :unprocessable_entity
  #   end
  # end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
  
    yield resource if block_given?
  
    if resource.errors.empty?
      resource.update(status: User.statuses[:active], is_verified: User.statuses[:verified],unconfirmed_email: "confirmed")
      render json: { message: 'Confirmation successful.' }
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
end
