class SuppliersController < ApplicationController
  layout "supplier"

  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @supplier = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      session[:supplier_id] = @supplier.id
      redirect_to @supplier, notice: "Supplier was successfully created"
    else
      render action: "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, notice: 'Supplier was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_path, notice: 'Supplier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:company_name, :address, :email, :username, :password, :password_confirmation)
  end

end
