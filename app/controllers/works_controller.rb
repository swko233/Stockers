class WorksController < ApplicationController

	def new
		@work = Work.new
	end

	def create
		work = Work.new(work_params)
		if work.save
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

