class ConsumersController < ApplicationController
    before_action :set_consumer, only: [:notification]

	def index
		@consumers = Consumer.all
	end

	def new
		@consumer = Consumer.new
	end

	def edit
		@consumer = Consumer.find(params[:id])
	end

	def notification
		@consumer = current_consumer
	end

	def create
		@consumer = Consumer.new(consumer_params)
	  @consumer.texts = false
	  @consumer.result_email = true
		@consumer.total_points = 0
		@consumer.phone_number = @consumer.phone_number.split('').select{|x| x.to_i.to_s == x.to_s}.join
		# Sends email to user when user is created.
		@consumer.username = @consumer.username.downcase

		if @consumer.save
			@consumer.username = @consumer.username.downcase
			session[:consumer_id] = @consumer.id
			CompanyMailer.welcome_email(@consumer).deliver
			redirect_to consumer_path(@consumer), notice: "#{@consumer.username.capitalize} was successfully created."
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
		if @consumer.save
			redirect_to consumer_path(@consumer), notice: "#{@consumer.username.capitalize}'s info was successfully updated."
		else
			render action: "edit"
		end
	end

	def show
		@consumer = Consumer.find(params[:id])
	end

	private
	def consumer_params
		params.require(:consumer).permit(:username, :email, :password, :password_confirmation, :address, :first_name, :last_name, :created_at, :updated_at, :phone_number, :texts, :result_email)
	end

	def set_consumer
    	@consumer = current_consumer
  	end

end
