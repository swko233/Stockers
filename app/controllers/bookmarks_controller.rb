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
  	@bookmark = Bookmark.find(params[:id])
  	if @bookmark.destroy
  		redirect_to user_path(current_user.id) #仮に
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
