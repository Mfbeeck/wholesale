class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @supplier = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new user_params

    if @supplier.save
      redirect_to root_path, notice: "Supplier was successfully created"
    else
      render action: "new"
    end
  end

  def show
  end

  def edit
  end

  def update
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

  def user_params
    params.require(:supplier).permit(:username, :password, :password_confirmation)
  end

end
