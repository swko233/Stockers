class BookmarksController < ApplicationController
  def new
  	@bookmark = Bookmark.new
  end

  def create
  	@bookmark = Bookmark.new(bookmark_params)
  	@bookmark.user_id = current_user.id
  	if @bookmark.save
  		redirect_to edit_bookmark_path(@bookmark.id) #仮に
  	else
  		redirect_to new_bookmark_path #仮に
  	end
  end

  def add_bookmark #他ユーザーのブックマークを自分のブックマークに追加
    @added_bookmark = Bookmark.find(params[:id])
    bookmark = Bookmark.new
    bookmark.user_id = current_user.id
    bookmark.service_name = @added_bookmark.service_name
    bookmark.url = @added_bookmark.url
    if @added_bookmark.is_work == true #自作サービスの場合
      bookmark.is_work = true
      bookmark.work_id = @added_bookmark.work_id
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
    bookmark = Bookmark.new
    bookmark.service_name = @added_work.service_name
    bookmark.url = @added_work.url
    bookmark.user_id = current_user.id
    bookmark.is_work = true
    bookmark.work_id = @added_work.id
    bookmark.tag_list = @added_work.tag_list  #タグの継承
    if bookmark.save
      redirect_to user_path(current_user.id)
    else
      redirect_to work_path(@added_work.id)
    end
  end

  def edit
  	@bookmark = Bookmark.find(params[:id])
  end

  def update
  	@bookmark = Bookmark.find(params[:id])
  	if @bookmark.update(bookmark_params)
  		redirect_to user_path(current_user.id) #仮に
  	else
  		redirect_to new_bookmark_path #仮に
  	end
  end

  def destroy
  	bookmark = Bookmark.find(params[:id])
  	if bookmark.destroy
      respond_to do |format|
        format.html { redirect_to user_path(current_user.id) } #仮に
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
