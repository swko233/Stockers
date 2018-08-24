class WorksController < ApplicationController

	def new
		@work = Work.new
	end

	def create
		@work = Work.new(work_params)
		@work.user_id = current_user.id
		 #2つ以上おすすめ設定しようとしていないかチェック
	    if params[:work][:is_recommended] == "true" && Work.where(user_id: current_user.id).where(is_recommended: true).count >= 1
	      @too_many_recommended_flag = true
	      render 'new'
	      return
	    end
		if @work.save
			redirect_to user_path(current_user.id)
		else
			@service_name_errmsg = @work.errors.full_messages_for(:service_name)
	      	@url_errmsg = @work.errors.full_messages_for(:url)
	      	# urlが重複する場合
		    if @url_errmsg[0] == "Url translation missing: ja.activerecord.errors.models.work.attributes.url.taken"
		    	@already_exist_flag = true
		   	end
	  		render 'new'
		end
	end

	def index
		@work = Work.new
		render 'new'
	end

	def show
		@work = Work.find(params[:id])
		@comment = Comment.new
		unless @work.nil?
			@my_work_bookmark = current_user.bookmarks.find_by(work_id: @work.id)
		end
	end

	def edit
  		@work = Work.find(params[:id])
  	end

	def update
  	@work = Work.find(params[:id])
    #3つより多くおすすめ設定しようとしていないかチェック
    if @work.is_recommended == false
	    if params[:work][:is_recommended] == "true" && Work.where(user_id: current_user.id).where(is_recommended: true).count >= 1
	      @too_many_recommended_flag = true #trueという文字列が代入されていることに注意
	      # binding.pry
	      render 'edit' and return
	    end
	end
    # binding.pry
  	if @work.update(work_params)
  		redirect_to work_path(@work.id) #仮に
  	else
  		@service_name_errmsg = @work.errors.full_messages_for(:service_name)
      	@url_errmsg = @work.errors.full_messages_for(:url)
      	# urlが重複する場合
      	if @url_errmsg[0] == "Url translation missing: ja.activerecord.errors.models.work.attributes.url.taken"
        @already_exist_flag = true
      	end
      	render 'edit'
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

