class BookmarksController < ApplicationController
  before_action :authenticate_user!
  
  def new
  	@bookmark = Bookmark.new
  end

  def create
  	@bookmark = Bookmark.new(bookmark_params)
  	@bookmark.user_id = current_user.id
    #3つより多くおすすめ設定しようとしていないかチェック
    if params[:bookmark][:is_recommended] == "true" && Bookmark.where(user_id: current_user.id).where(is_recommended: true).count >= 3
      @too_many_recommended_flag = true
      render 'new'
      return
    end
    if @bookmark.save
    	redirect_to user_path(current_user.id) #仮に
    else
      #バリデーションエラーメッセージ表示用
      @service_name_errmsg = @bookmark.errors.full_messages_for(:service_name)
      @url_errmsg = @bookmark.errors.full_messages_for(:url)
      ##urlが重複する場合
      if @url_errmsg[0] == "Url translation missing: ja.activerecord.errors.models.bookmark.attributes.url.taken"
        @already_exist_flag = true
      end
      render 'new'
    end
  end

  # create時のバリデーションエラーのページをリロードした場合の対策
  def index
    @bookmark = Bookmark.new
    render 'new'
  end

  def add_bookmark #他ユーザーのブックマークを自分のブックマークに追加
    @added_bookmark = Bookmark.find(params[:id])
    bookmark = Bookmark.new
    bookmark.user_id = current_user.id
    bookmark.service_name = @added_bookmark.service_name
    bookmark.url = @added_bookmark.url
    #自作サービスの場合(他ユーザーのブックマーク欄にある自作サービス、フォルダアイコンにより追加)
    if @added_bookmark.is_work == true
      bookmark.is_work = true
      bookmark.work_id = @added_bookmark.work_id
      bookmark.service_image_id = @added_bookmark.service_image_id
    end
    unless @added_bookmark.service_image_id.nil?
      bookmark.service_image_id = @added_bookmark.service_image_id
    end
    bookmark.tag_list = @added_bookmark.tag_list  #タグの継承
    if bookmark.save
      respond_to do |format|
        format.html { redirect_to user_path(current_user.id) }
        format.js do
          @this_bookmark = @added_bookmark
        end
      end
    else
      redirect_to new_bookmark_path
    end
  end

  def add_work_bookmark #自作サービスをブックマーク
    @added_work = Work.find(params[:id])
    # 既に追加されていないかチェック
    if current_user.bookmarks.find_by(work_id: @added_work.id).nil?
      bookmark = Bookmark.new
      bookmark.service_name = @added_work.service_name
      bookmark.url = @added_work.url
      bookmark.user_id = current_user.id
      bookmark.is_work = true
      bookmark.work_id = @added_work.id
      bookmark.service_image_id = @added_work.service_image_id
      bookmark.tag_list = @added_work.tag_list  #タグの継承
      if bookmark.save
        redirect_back(fallback_location: root_path)
      else
        redirect_to work_path(@added_work.id)
      end
    else
      flash[:notice] = "すでにブックマークに追加されています"
      redirect_to user_path(current_user.id)
    end
  end



  def edit
  	@bookmark = Bookmark.find(params[:id])
  end

  def update
  	@bookmark = Bookmark.find(params[:id])
    #3つより多くおすすめ設定しようとしていないかチェック
    if @bookmark.is_recommended == false
      if params[:bookmark][:is_recommended] == "true" && (Bookmark.where(user_id: current_user.id).where(is_recommended: true).count >= 3)
        @too_many_recommended_flag = true
        render 'edit' and return
      end
    end
  	if @bookmark.update(bookmark_params)
  		redirect_to user_path(current_user.id) #仮に
  	else
  		@service_name_errmsg = @bookmark.errors.full_messages_for(:service_name)
      @url_errmsg = @bookmark.errors.full_messages_for(:url)
      # urlが重複する場合
      if @url_errmsg[0] == "Url translation missing: ja.activerecord.errors.models.bookmark.attributes.url.taken"
        @already_exist_flag = true
      end
      render 'edit'
  	end
  end

  # update時のバリデーションエラーのページをリロードした場合の対策
  def show
    @bookmark = Bookmark.find(params[:id])
    render 'edit'
  end

  def destroy
  	bookmark = Bookmark.find(params[:id])
  	if bookmark.destroy
      respond_to do |format|
        format.html { redirect_to user_path(current_user.id) }
        #フォルダアイコンを押して解除した場合
        format.js do
          @this_bookmark = Bookmark.find(params[:this_bookmark_id])
        end
      end
  	else
  		redirect_to new_bookmark_path #仮に
  	end
  end

  private

  def bookmark_params
  	params.require(:bookmark).permit(:service_name,:url,:overview,:description,:service_image,
  		:is_published,:is_recommended,:is_work,:folder_id,:tag_list)
  end


end
