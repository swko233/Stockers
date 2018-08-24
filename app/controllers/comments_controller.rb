class CommentsController < ApplicationController
	# def index
	# 	@comments = Work.find(params[:id]).comments
	# end

	def create
		comment = Comment.new(comment_params)
		comment.user_id = current_user.id
		comment.work_id = params[:work_id]
		if comment.save
			redirect_to work_path(comment.work.id, anchor:'work-comments')
		else
			redirect_to work_path(comment.work.id, anchor:'work-comments')
		end

	end

	def destroy
		comment = Comment.find(params[:id])
		if comment.destroy
			redirect_to work_path(comment.work.id, anchor:'work-comments')
		else
			redirect_to work_path(comment.work.id, anchor:'work-comments')
		end
	end

	def comment_params
		params.require(:comment).permit(:comment)
	end
end
