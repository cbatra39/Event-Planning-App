class ProfilesController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :authenticate_user!
  
    def show
      @profile = current_user.profile
      render json: { profile: @profile, email: current_user.email, image_url: @profile.image.present? ? url_for(@profile.image) : nil}, status: :ok
    end
  
    def create
      if current_user.profile.present?
        render json: { error: "Profile already exists for the current user" }, status: :unprocessable_entity
      else
        image = params[:image]
        if image.present?
            @profile = current_user.build_profile(set_params)
            @profile.image.attach(image)
            if @profile.save
            render json: { message: "Profile created", data: @profile, image_url:url_for(@profile.image)}, status: :ok
            else
            render json: { message: "Profile not created" }, status: :unprocessable_entity
            end
        end
      end
    end
  
    def update 
      @profile = current_user.profile
      if @profile.nil?
        render json: { error: "first create a  profile"},status: :unprocessable_entity
      elsif @profile.update(set_params)
        if @profile.image.present?
            @profile.image.attach(params[:image])
        end
        render json: { message: "Profile updated successfully", data: @profile, email: current_user.email ,image_url: @profile.image.present? ? url_for(@profile.image) : nil}, status: :ok
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
      params.permit(:first_name, :last_name, :dob, :address, :phone_number)
    end
  end
  