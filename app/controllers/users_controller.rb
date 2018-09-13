class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :ensure_active_user, except: [:index]

	def index
		@users = User.where(deleted_at: nil)
	end

	def show
		@user = User.find(params[:id])
		#フォローボタンを押しても表示が変更されないように移動（不具合があった）
		@following_number = @user.following.count
		@follower_number = @user.followers.count
		@bookmarks = Bookmark.where(user_id: @user.id)
		@works = Work.where(user_id: @user.id)
		@recommended_bookmarks = @bookmarks.where(is_recommended: true)
		@recommended_work = @works.find_by(is_recommended: true)
		#おすすめ自作サービスをブックマークに追加しているかどうかの判定用変数(追加している場合はブックマーク解除に使用)
		#Ajaxでrenderした後は、ビューで変数定義し直す

		#念のため、ブックマーク内に重複したURLがないかどうかチェック
		if @recommended_work.present?
			@my_work_bookmark = current_user.bookmarks.find_by(url: @recommended_work.url)
			@my_work_bookmark = current_user.bookmarks.find_by(work_id: @recommended_work.id) if @my_work_bookmark.nil?
		end
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
		# アドレス直打ち対策
		if @user != current_user
			redirect_to user_path(current_user.id)
		end
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			# flash[:notice] = "ユーザー情報を変更しました"
			redirect_to user_path(current_user.id)
		else
			@email_errmsg = @user.errors.full_messages_for(:email)
		    if @email_errmsg[0] == "Eメール translation missing: ja.activerecord.errors.models.user.attributes.email.taken"
		    	@email_exist_flag = true
		    end
		    @name_errmsg = @user.errors.full_messages_for(:name)
		    @nickname_errmsg = @user.errors.full_messages_for(:nickname)
			# binding.pry
			render 'edit'
		end
	end

	def password_update
		@user = User.find(params[:id])
	    if @user.update_with_password(user_params)
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
		#フォローボタンを押しても表示が変更されないように移動（不具合があった）
		@users = @user.following.where(deleted_at: nil)
		@following_number = @user.following.where(deleted_at: nil).count
		@follower_number = @user.followers.where(deleted_at: nil).count
		render 'show_following'
	end

	def followers
		@user = User.find(params[:id])
		#フォローボタンを押しても表示が変更されないように移動（不具合があった）
		@users = @user.followers.where(deleted_at: nil)
		@following_number = @user.following.where(deleted_at: nil).count
		@follower_number = @user.followers.where(deleted_at: nil).count
		render 'show_followers'
	end

	def destroy
		@user = current_user
		if @user.soft_delete
			sign_out(@user)
			redirect_to root_path
			flash[:notice] = "退会しました"
		else
			redirect_to user_path(@user.id)
			flash[:alert] = "エラーが発生しました"
		end
	end

	private

	def user_params
		params.require(:user).permit(:name,:nickname,:image,:introduction,:email,:password, :password_confirmation, :current_password)
	end

	def ensure_active_user
		user = User.find(params[:id])
		unless user.deleted_at.nil?
			redirect_back(fallback_location: root_path)
		end
	end

end
