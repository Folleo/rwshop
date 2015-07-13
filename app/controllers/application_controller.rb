class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_order
  after_filter :flash_to_headers

  def current_order
    if !session[:order_id].nil?
      # Find from session
      Order.find(session[:order_id])
    else
      if user_signed_in?
        # Try to load from the database unfinished order
        order = Order.where(:user_id => current_user.id, :order_status_id => 1).order(:updated_at).last
        if !order.nil?
          order
        else
          Order.new
        end
      else
        # Unregistered user vithow session
        Order.new
      end
    end
  end

  def require_user
    if signed_in? and current_user.role?(Role::USER)
      true
    else
      render_403
    end
  end

  def render_403
    respond_to do |format|
      format.html { render file: 'errors/403', layout: false, status: 403 }
      format.any  { head :not_found }
    end
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: 404 }
      format.any  { head :not_found }
    end
  end

  def is_number? string
    true if Float(string) rescue false
  end

  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers['X-Message-Type'] = flash_type.to_s
    flash.discard
  end

  private

  def flash_message
    result = ''
    [:error, :warning, :notice].each do |type|
      result += flash[type] unless flash[type].blank?
    end
    result.blank? ? '' : result
  end

  def flash_type
     [:error, :warning, :notice].select { |type| !flash[type].blank? }.first
  end

end
