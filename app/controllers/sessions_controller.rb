class SessionsController < ApplicationController
  layout "supplier"

  def new
  end

  def create
  @supplier = Supplier.find_by(username: params[:username]).try(:authenticate, params[:password])

  if @supplier
    session[:supplier_id] = @supplier.id
    redirect_to suppliers_path
    else
    render action: 'new'
    end
  end

  def destroy
    session[:supplier_id] = nil
    redirect_to root_path
  end

end
