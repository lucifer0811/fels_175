class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @q = User.search(params[:q])
    @users = @q.result(distinct: true).order("created_at DESC")
      .page(params[:page]).per(Settings.users.per_page)
    @index = params[:page].nil? ? 0 :
      ((params[:page].to_i - 1) * (Settings.users.per_page))
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html {redirect_to admin_users_path,
        notice: t("controller.users.notice")}
      format.js
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email
  end
end
