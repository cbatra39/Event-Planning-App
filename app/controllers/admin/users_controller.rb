class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show  destroy ]

  # GET /users or /users.json
  def index
    @users = User.all.where.not(is_admin: true)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  def update_status
    @user = User.find(params[:id])
    @user.update(status: @user.status=="active" ? "suspended" : "active")
    if(@user.status == "suspended")
      @events = Event.all.where(user_id:params[:id])
      AccountSuspensionMailer.suspended(@user).deliver_now
      @events.each do |e|
        e.update(is_approved:false)
      end
    end
    redirect_to admin_users_url
  end
  

  # DELETE /users/1 or /users/1.json
  def destroy
    AccountSuspensionMailer.deleted(@user).deliver_now
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
