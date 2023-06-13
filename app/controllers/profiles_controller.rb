class ProfilesController < ApplicationController
  include Responses
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!
    def show
      @profile = current_user.profile
    
      if @profile.nil?
        error_404("Profile not found")
      else
        follower_count = UserFollower.where(user_id: current_user.id).count
        data = {
          "dob": @profile.dob,
          "phone_number": @profile.phone_number,
          "address": @profile.address,
          "first_name": @profile.first_name,
          "last_name": @profile.last_name,
          "email": current_user.email,
          "profile_image": @profile.image.present? ? url_for(@profile.image) : nil,
          "follower_count": follower_count.present? ? follower_count : nil
        }
    
        success(data: data)
      end
    end
    
    
    def create
  
      if current_user.profile.present?
         error("Profile already exists for the current user" )
        
      else
        @profile = current_user.build_profile(set_params)
        image = params[:image]
        if image.present?
            @profile.image.attach(image)
        end
        if @profile.save
          success("Profile created")
        else
        error("Profile not created" )
        end
      end
    
    end
  

    def update 
      @profile = current_user.profile
      if @profile.nil?
        error("first create a  profile")
      elsif @profile.update(set_params)
        image = params[:image]
        if image.present?
            @profile.image.attach(image)
        end
        success( "Profile updated successfully")
      else
        error("Profile not updated" )
      end
    end
  
    def destroy 
      @profile = current_user.profile
      if @profile
        if @profile.destroy
          success("Profile deleted" )
        end
      else
        error("Profile does not exist")
      end
    end
  
    private
  
    def set_params
      params.permit(:first_name, :last_name, :dob, :address, :phone_number)
    end
  end
  