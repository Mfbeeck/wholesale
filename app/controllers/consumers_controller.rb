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
		@consumer.save
		redirect_to consumer_path(@consumer)
	end

	def update
		@consumer = Consumer.find(params[:id])
		@consumer.update(consumer_params)
		redirect_to consumers_path
		flash.notice = "The consumer \"#{@consumer.username}\" was successfully updated."
	end

	def show
		@consumer = Consumer.find(params[:id])
	end

	private
	def consumer_params
		params.require(:consumer).permit(:username, :email, :password, :password_confirmation, :address, :first_name, :last_name, :created_at, :updated_at)
	end

end
