class StaticPagesController < ApplicationController
  def home
    @activities = PublicActivity::Activity.where(owner: user)
      .order(created_at: :desc).page(params[:page]).per Settings.users.per_page
  end

  def help
  end

  def contact
  end

  def about
  end
end
