class Admin::HomeController < ApplicationController
    before_action :authenticate_user!
    
    def dashboard
    end
  
    def profile
    end

end