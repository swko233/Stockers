class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
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
