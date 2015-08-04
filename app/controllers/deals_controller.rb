class DealsController < ApplicationController

  before_action :set_deal, only: [:show, :destroy, :edit, :update]
  before_action :set_supplier, only: [:create, :edit, :update, :destroy]
  # before_action :set_consumer, only: [:show]


  def index
    @deals = Deal.all
  end

  def new
    @deal = Deal.new
  end

  def show
    @order = Order.new
    # @consumer = current_consumer
  end

  def edit
  end

  def update
    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to @supplier, notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @deal = @supplier.deals.new(deal_params)

    if @deal.save
      #session[:supplier_id] = @supplier.id
      redirect_to @supplier, notice: "Deal was successfully created"
    else
      render action: "new"
    end
  end

  def destroy
    @deal.destroy
    respond_to do |format|
      format.html { redirect_to supplier_path(@supplier), notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def checkout
    @deal = Deal.find(params[:id])
  end


  private

  def set_supplier
    #security fix
    #@supplier = current_supplier.suppliers.find(params[:supplier_id])
    @supplier = current_supplier
  end

  def set_deal
    @deal = Deal.find(params[:id])
  end

  def deal_params
    params.require(:deal).permit(:name, :description, :price, :threshold, :start_date, :end_date, :suplier_id, :url)
  end

end
