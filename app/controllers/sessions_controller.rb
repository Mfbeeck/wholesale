class SessionsController < ApplicationController

  def new_supplier

  end

  def new_consumer
  end

  def login_supplier
    @supplier = Supplier.find_by(username: params[:username]).try(:authenticate, params[:password])
    if current_consumer
      session[:consumer_id] = nil
    end
    if @supplier
      session[:supplier_id] = @supplier.id
      redirect_to supplier_path(@supplier)
    else
      render action: 'new_supplier'
    end
  end

  def login_consumer
    @consumer = Consumer.find_by(username: params[:username]).try(:authenticate, params[:password])
    if current_supplier
      session[:supplier_id] = nil
    end
    if @consumer
      session[:consumer_id] = @consumer.id
      redirect_to consumer_path(@consumer)
    else
      render action: 'new_consumer'
    end
  end


  def destroy
    if current_supplier
      session[:supplier_id] = nil
    elsif current_consumer
      session[:consumer_id] = nil
    end
    redirect_to root_path
  end

end
