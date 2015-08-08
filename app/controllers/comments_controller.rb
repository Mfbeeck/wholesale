class CommentsController < ApplicationController
	before_action :set_array_of_current_consumer_orders_deal_ids, only: [:create]


	def create
      @deal = Deal.find(params[:deal_id])
		  if @current_consumer_orders_deal_ids.include? @deal.id
		  @comment = Comment.new(comment_params)
		  @comment.deal_id = params[:deal_id]
		  @comment.consumer_id = current_consumer.id
		  @comment.author_name = current_consumer.username
		  respond_to do |format|
		  	if @comment.save
	    		format.html { redirect_to deal_path(@deal, comment: @comment.id) }
		        format.json { render :show, status: :created, location: @comment }
		    else
		    	format.html { render :new }
	    		format.json { render json: @comment.errors, status: :unprocessable_entity }
		  	end
		  end
		end
	end

	def show
    	@comment = Comment.find(params[:id])
  	end

	def destroy
	    @deal = Deal.find(params[:deal_id])
	    @comment = Comment.find(params[:id])
	    @comment.destroy
	    # @xhr_comment.destroy
	  #   respond_to do |format|
		 #  	if @comment.save
	  #   		format.html { redirect_to deal_path(@deal, comment: @comment.id) }
		 #        format.json { render :show, status: :created, location: @comment }
		 #    else
		 #    	format.html { render :new }
	  #   		format.json { render json: @comment.errors, status: :unprocessable_entity }
		 #  	end
	  # end
	    redirect_to deal_path(@deal)
    end

	private

	def comment_params
	  params.require(:comment).permit(:author_name, :body, :deal_id, :consumer_id, )
	end

end
