class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private

  helper_method :current_supplier

  def current_supplier
    @current_supplier ||= Supplier.find(session[:supplier_id]) if session[:supplier_id]
  end

  def require_logged_in
    return true if current_supplier

    redirect_to root_path
    return false
  end
end
