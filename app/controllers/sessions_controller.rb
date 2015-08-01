class SessionsController < ApplicationController

  def new_supplier
    if current_supplier.nil?
    else
      @supplier = current_supplier
      redirect_to supplier_path(@supplier)
    end
  end

  def new_consumer
  end

  def login_supplier
    @supplier = Supplier.find_by(username: params[:username]).try(:authenticate, params[:password])

    if @supplier
      session[:supplier_id] = @supplier.id
      redirect_to suppliers_path
    else
      render action: 'new_supplier'
    end
  end

  def login_consumer
    @consumer = Consumer.find_by(username: params[:username]).try(:authenticate, params[:password])

    if @consumer
      session[:consumer_id] = @consumer.id
      redirect_to consumers_path
    else
      render action: 'new_consumer'
    end
  end


  def destroy
    session[:supplier_id] = nil
    redirect_to root_path
  end

end
