class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show  destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  def update_status
    @user = User.find(params[:id])
    @user.update(status: @user.status=="active" ? "inactive" : "active")
    redirect_to admin_users_url
  end
  

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
