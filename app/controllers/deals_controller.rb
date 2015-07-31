class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :destroy, :edit, :update]

  def index
    @deals = Deal.all
  end

  def new
    @deal = Deal.new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to @deal, notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @deal = Deal.new(deal_params)

    if @deal.save
      #session[:supplier_id] = @supplier.id
      redirect_to @deal, notice: "Deal was successfully created"
    else
      render action: "new"
    end
  end

  def destroy
    @deal.destroy
    respond_to do |format|
      format.html { redirect_to deals_path, notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  def set_deal
    @deal = Deal.find(params[:id])
  end

  def deal_params
    params.require(:deal).permit(:name, :description, :price, :threshold, :start_date, :end_date)
  end

end
