class WorksController < ApplicationController

	def new
		@work = Work.new
	end

	def create
		@work = Work.new(work_params)
		@work.user_id = current_user.id
		if @work.save
			redirect_to user_path(current_user.id)
		else
			@service_name_errmsg = @work.errors.full_messages_for(:service_name)
	      	@url_errmsg = @work.errors.full_messages_for(:url)
	      	# binding.pry
	  		render 'new'
		end
	end

	def index
		@work = Work.new
		render 'new'
	end

	def show
		@work = Work.find(params[:id])
		unless @work.nil?
			@my_work_bookmark = current_user.bookmarks.find_by(work_id: @work.id)
		end
	end

	def destroy
		work = Work.find(params[:id])
		if work.destroy
			redirect_to user_path(current_user.id)
		else
			redirect_to new_work_path
		end
	end

	private

	def work_params
		params.require(:work).permit(:service_name,:url,:release_date,:overview,:description,:service_image,
  		:is_published,:is_recommended,:tag_list)
  	end
end

