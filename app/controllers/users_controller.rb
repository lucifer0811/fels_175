class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
  end

  def following
    @title = t "user.title.following"
    @user  = User.find_by id: params[:id]
    @users = @user.following.paginate page: params[:page]
    render "show_follow"
  end

  def followers
    @title = t "user.title.followers"
    @user  = User.find_by id: params[:id]
    @users = @user.followers.paginate page: params[:page]
    render "show_follow"
  end

  private
  def users_params
    params.require(:user).permit :name, :email, :password, :password_confirmation,
      :avatar
  end
end
