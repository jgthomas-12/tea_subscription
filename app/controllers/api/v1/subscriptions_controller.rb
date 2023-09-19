class Api::V1::SubscriptionsController < ApplicationController
  def create
    customer = Customer.find(params[:customer_id])

    if customer
      subscription = customer.subscriptions.new(subscription_params)
      if subscription.save
        render json: { success: "Subscription added successfully" }, status: :created
      else
        render json: { error: subscription.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      render json: { error: "Customer not found" }, status: :not_found
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :tea_id)
  end
end