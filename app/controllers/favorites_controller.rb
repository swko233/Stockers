class FavoritesController < ApplicationController
	def create
		work = Work.find(params[:work_id])
		@user = work.user
		favorite = Favorite.new(user_id: current_user.id, work_id: params[:work_id])
		if favorite.save
			respond_to do |format|
				format.html {redirect_to @user}
				format.js  {@this_work = work}
			end
		else
			redirect_to new_bookmark_path
		end
	end

	def destroy
		work = Work.find(params[:work_id])
		@user = work.user
		favorite = Favorite.find_by(work_id: params[:work_id])
		if favorite.destroy
			respond_to do |format|
				format.html {redirect_to @user}
				format.js {@this_work = work}
			end
		else
			redirect_to new_bookmark_path
		end
	end
end
