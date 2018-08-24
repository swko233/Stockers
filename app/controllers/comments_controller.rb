class CommentsController < ApplicationController
	# def index
	# 	@comments = Work.find(params[:id]).comments
	# end

	def create
		comment = Comment.new(comment_params)
		comment.user_id = current_user.id
		comment.work_id = params[:work_id]
		binding.pry
		if comment.save
			redirect_to work_path(comment.work.id)
		else
			flash[:notice] = "コメントに失敗しました"
			redirect_to work_comments_path(comment.work.id)
		end

	end

	def destroy
		comment = Comment.find(params[:id])
		if comment.destroy
			redirect_to work_path(comment.work.id)
		else
			flash[:notice] = "コメントに失敗しました"
			redirect_to comments_path
		end
	end

	def comment_params
		params.require(:comment).permit(:comment)
	end
end
