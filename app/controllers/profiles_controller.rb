class ProfilesController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :authenticate_user!
  
    def show
      @profile = current_user.profile
      image_url = url_for(current_user.image)  if current_user.image.attached?
      render json: { profile: @profile, email: current_user.email, image_url: image_url}, status: :ok
    end
  
    def create
      if current_user.profile.present?
        render json: { error: "Profile already exists for the current user" }, status: :unprocessable_entity
      else
        @profile = current_user.build_profile(set_params)
        if @profile.save
          render json: { message: "Profile created", data: @profile}, status: :ok
        else
          render json: { message: "Profile not created" }, status: :unprocessable_entity
        end
      end
    end
  
    def update 
      @profile = current_user.profile
      if @profile.nil?
        render json: { error: "first create a  profile"},status: :unprocessable_entity
      elsif @profile.update(set_params)
        render json: { message: "Profile updated successfully", data: @profile }, status: :ok
      else
        render json: { message: "Profile not updated" }, status: :unprocessable_entity
      end
    end
  
    def destroy 
      @profile = current_user.profile
      if @profile
        if @profile.destroy
          render json: { message: "Profile deleted" }, status: :ok
        end
      else
        render json: { message: "Profile does not exist" }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_params
      params.permit(:first_name, :last_name, :dob, :address, :phone_number, :status)
    end
  end
  