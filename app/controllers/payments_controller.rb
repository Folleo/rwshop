class PaymentsController < ApplicationController
  before_action :authenticate_user!, :require_user

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      if @payment.process
        order = current_order
        order.order_status_id = 2
        order.user_id = current_user.id
        order.save
        order.order_items.each do |order_item|
          order_item.update_sales
        end
        session[:order_id] = nil
        redirect_to root_path and return
      end
    end
    render 'new'
  end

  private
  def payment_params
    params.require(:payment).permit(
        :first_name,
        :last_name,
        :credit_card_number,
        :expiration_month,
        :expiration_year,
        :card_security_code,
        :amount
    )
  end
end
