class ConsumersController < ApplicationController
	def index
		@consumers = Consumer.all
	end

	def new
		@consumer = Consumer.new
	end

	def edit
		@consumer = Consumer.find(params[:id])
	end

	def create
		@consumer = Consumer.new(consumer_params)
		@consumer.total_points = 0
		if @consumer.save
			session[:consumer_id] = @consumer.id
			redirect_to consumer_path(@consumer), notice: "#{@consumer.username} was successfully created"
		else
			render action: "new"
		end
	end

	def destroy
		@consumer = Consumer.find(params[:id])
		@consumer.destroy
		redirect_to consumers_path
		flash.notice = "The consumer \"#{@consumer.email}\" was successfully deleted."
	end

	def update
		@consumer = Consumer.find(params[:id])
		@consumer.update(consumer_params)
		redirect_to consumer_path(@consumer)
		flash.notice = "The consumer \"#{@consumer.username}\" was successfully updated."
	end

	def show
		@consumer = Consumer.find(params[:id])
	end

	private
	def consumer_params
		params.require(:consumer).permit(:username, :email, :password, :password_confirmation, :address, :first_name, :last_name, :created_at, :updated_at, :phone_number)
	end

end
