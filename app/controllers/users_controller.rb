class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
  end

  private
  def users_params
    params.require(:user).permit :name, :email, :password, :password_confirmation,
      :avatar
  end
end
