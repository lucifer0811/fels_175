class RelationshipsController < ApplicationController
  before_action :logged_in_user
  def create
    @other_user = User.find_by id: params[:other_user_id]
    current_user.active_relationships.create(followed_id: @other_user.id)
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    @other_user = Relationship.find_by(id: params[:id]).followed
    current_user.active_relationships.find_by(followed_id: @other_user.id).destroy
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
