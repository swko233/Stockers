class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
		@bookmarks = Bookmark.where(user_id: @user.id)
		@works = Work.where(user_id: @user.id)
		@recommended_bookmarks = @bookmarks.where(is_recommended: true)
		@recommended_work = @works.find_by(is_recommended: true)
		#タグ一覧取得
		tags = []
		@bookmarks.each do |bookmark|
			if @user == current_user
				tags += bookmark.tag_list
			else
				tags += bookmark.tag_list if bookmark.is_published == true
			end
		end
		@tag_all = tags.uniq
		##タグ個数カウント
		@tag_count = []
		@tag_all.each do |tag|
			tag_number = tags.count(tag)
			@tag_count << tag_number
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	# def update
	# 	@user = User.find(params[:id])
	# 	if @user.save(user_params)
	# end

	def search_bookmark
		@user = User.find(params[:id])
		target_tag = params[:tag]
		@bookmarks = Bookmark.tagged_with([target_tag]).where(user_id: @user.id)
		@all_bookmarks = Bookmark.where(user_id: @user.id)
		#タグ一覧取得
		tags = []
		@all_bookmarks.each do |bookmark|
			if @user == current_user
				tags += bookmark.tag_list
			else
				tags += bookmark.tag_list if bookmark.is_published == true
			end
		end
		@tag_all = tags.uniq
		##タグ個数カウント
		@tag_count = []
		@tag_all.each do |tag|
			tag_number = tags.count(tag)
			@tag_count << tag_number
		end
	end

	def search
		@user = User.find(params[:id])
		@bookmarks = Bookmark.where(user_id: @user.id).where('service_name LIKE(?)', "%#{params[:keyword]}%")
		respond_to do |format|
			format.json {render 'search_bookmark',json: @bookmarks}
		end
	end

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
