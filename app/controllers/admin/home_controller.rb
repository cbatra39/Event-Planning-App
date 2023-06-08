class Admin::HomeController < ApplicationController
    before_action :authenticate_user!
    
    def dashboard
    end
  
    def profile
      @user = current_user
      @resource = @user
      @resource_name = :user 
      render 'profile', resource: @resource, resource_name: @resource_name

     
    end

    def update_profile
        @profile = current_user.profile 
        @profile.user_id = current_user.id 
        if @profile.update(profile_params)
          redirect_to admin_profile_path
        else
          render :profile
        end
    end
      
      private
      
      def profile_params
        params.require(:profile).permit(:first_name, :last_name,:dob, :phone_number, :address, :image)
      end
    
end