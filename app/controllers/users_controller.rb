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
		if User.exists?(params[:id])
			@user = User.find(params[:id])
			# アドレス直打ち対策
			if @user != current_user
				redirect_to user_path(current_user.id)
			end
		else
			#見つからなかったというページを作る
			redirect_to user_path(current_user.id)
		end
	end

	def update
		@user = User.find(params[:id])
		if @user.save(user_params)
			flash[:notice] = "ユーザー情報を変更しました"
			redirect_to edit_user_path(current_user.id)
		else
			flash[:notice] = "保存に失敗しました"
			redirect_to edit_user_path(current_user.id)
		end
	end

	def password_update
		@user = User.find(params[:id])
	    if @user.update_with_password(password_params)
	      	bypass_sign_in(@user)
			flash[:notice] = "パスワードを変更しました"
			redirect_to edit_user_path(current_user.id)
	    else
	        flash[:password_notice] = "パスワードが正しく設定されていません"
	        redirect_to edit_user_path(current_user.id)
	    end
	end

	def search_bookmark_tag #タグ検索
		@user = User.find(params[:id])
		target_tag = params[:tag]
		@all_bookmarks = Bookmark.where(user_id: @user.id)
		@bookmarks = Bookmark.tagged_with([target_tag]).where(user_id: @user.id)
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
		render 'search_bookmark'
	end

	def search_bookmark  #文字で検索
		@user = User.find(params[:id])
		@all_bookmarks = Bookmark.where(user_id: @user.id)
		@bookmarks = Bookmark.search_bookmark(params[:search]).where(user_id: @user.id)
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

	# def search  #インクリメンタルサーチ
	# 	@user = User.find(params[:id])
	# 	@bookmarks = Bookmark.where(user_id: @user.id).where('service_name LIKE(?)', "%#{params[:keyword]}%")
	# 	respond_to do |format|
	# 		format.json {render 'search_bookmark',json: @bookmarks}
	# 	end
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

	private

	def user_params
		params.require(:user).permit(:name,:nickname,:image_id,:introduction,:email)
	end
	def password_params
			params.require(:user).permit(:password, :password_confirmation, :current_password)
	end
end
