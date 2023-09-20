class Api::V1::SubscriptionsController < ApplicationController
  def index
    customer = Customer.find(params[:customer_id])
    subscriptions = customer.subscriptions

    render json: subscriptions, each_serializer: SubscriptionSerializer
  end

  def create
    customer = Customer.find(params[:customer_id])

    if customer
      subscription = customer.subscriptions.new(subscription_params)
      if subscription.save
        render json: { success: "Subscription added successfully" }, status: :created
      else
        render json: { error: "Invalid parameters" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Customer not found" }, status: :not_found
    end
  end

  def destroy
    subscription = Subscription.find(params[:id])
    if subscription.destroy
      render json: { success: "Subscription deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete subscription" }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :tea_id)
  end
end
