class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @activities = PublicActivity::Activity.where(owner: @user)
      .order(created_at: :desc).page(params[:page]).per Settings.users.per_page
  end

  def index
    @q = User.search(params[:q])
    @users = @q.result(distinct: true).order("created_at DESC")
      .page(params[:page]).per(Settings.users.per_page)
  end

  private
  def users_params
    params.require(:user).permit :name, :email, :password, :password_confirmation,
      :avatar
  end
end
