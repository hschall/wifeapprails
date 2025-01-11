module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin

    # GET /admin/users
    def index
      @users = User.all
    end

    # GET /admin/users/:id/edit
    def edit
      @user = User.find(params[:id])
    end

    # PATCH/PUT /admin/users/:id
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "User updated successfully."
      else
        render :edit, alert: "Unable to update user."
      end
    end

    private

    def authorize_admin
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:role)
    end
  end
end

