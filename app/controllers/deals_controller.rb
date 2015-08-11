class DealsController < ApplicationController

  before_action :set_deal, only: [:show, :destroy, :edit, :update]
  before_action :set_supplier, only: [:create, :edit, :update, :destroy]
  before_action :check_if_supplier_logged_in, only: [:create, :update, :destroy, :edit, :new]
  before_action :set_array_of_current_consumer_orders_deal_ids, only: [:show]
  before_action :check_supplier_id_for_deals, only: [:show, :edit, :update]


  # before_action :set_consumer, only: [:show]

  def index
    @deals = Deal.where(threshold_reached: false).sort {|a,b| a.participants_left <=> b.participants_left}
    # (order_by participants_remaining)
    # @deals = Deal.filter_by(params)
    # Deal.where("product_type = 'Electronics'") #+ Deal.where("product_type = 'Video Games'")
  end

  def index_electronics
    @deals = Deal.where(:threshold_reached => false, :product_type => "Electronics").sort {|a,b| a.participants_left <=> b.participants_left}
  end

  def index_videogames
    @deals = Deal.where(:threshold_reached => false, :product_type => "Video Games").sort {|a,b| a.participants_left <=> b.participants_left}
  end

  def new
    @deal = Deal.new
  end

  def show
    @order = Order.new
    @comment = Comment.new
    @comment.deal_id = @deal.id
    @xhr_comment = Comment.find(params[:comment]) if (params[:comment]).present?

    if request.xhr?
        render 'comments/_comment', layout: false, locals: { comment: @xhr_comment }
    end
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
    @deal.threshold_reached = false

    if @deal.save
      #session[:supplier_id] = @supplier.id
      redirect_to suppliers_deals_path, notice: "Deal was successfully created"
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

  def check_supplier_id_for_deals
    if current_supplier.id != params[:id].to_i
      redirect_to supplier_path(current_supplier)
    else
    end
  end
  def participants_remaining
    @deal.threshold - @deal.orders.count
  end

  def set_supplier
    #security fix
    #@supplier = current_supplier.suppliers.find(params[:supplier_id])
    @supplier = current_supplier
  end

  def set_deal
    @deal = Deal.find(params[:id])
  end

  def deal_params
    params.require(:deal).permit(:name, :description, :price, :threshold, :start_date, :end_date, :suplier_id, :url, :product_type, :winning_order_id, :winners_shipping_address, :winners_shipping_address, :threshold_reached)
  end

end
