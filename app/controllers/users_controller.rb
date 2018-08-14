class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
		@bookmarks = Bookmark.where(user_id: @user.id)
		@works = Work.where(user_id: @user.id)
		@recommended_bookmarks = @bookmarks.where(is_recommended: true)
		@recommended_work = @works.find_by(is_recommended: true)
	end

	def edit
		@user = User.find(params[:id])
	end

	# def update
	# 	@user = User.find(params[:id])
	# 	if @user.save(user_params)
	# end

	def following
		@user = User.find(params[:id])
		@users = @user.following
		render 'show_following'
	end

	def followers
		@user = User.find(params[:id])
		@users = @user.followers
		render 'show_followers'
	end
end
