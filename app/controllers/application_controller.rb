class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private

  helper_method :current_supplier
  helper_method :current_consumer


  def current_supplier
    @current_supplier ||= Supplier.find(session[:supplier_id]) if session[:supplier_id]
  end

  def current_consumer
    if !current_supplier.id
    @current_consumer ||= Consumer.find(session[:consumer_id]) if session[:consumer_id]
    end
  end


  def require_logged_in
    return true if (current_supplier || current_consumer)

    redirect_to root_path
    return false
  end
end
