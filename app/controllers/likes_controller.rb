class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @post = Micropost.find(params[:liked_post_id])
    current_user.like(@post)
    respond_to do |format|
      # format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @post = Like.find(params[:id]).liked_post
    current_user.unlike(@post)
    respond_to do |format|
      # format.html { redirect_to @user }
      format.js
    end
  end
end
