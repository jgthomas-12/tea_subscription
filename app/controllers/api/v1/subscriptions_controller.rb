class Api::V1::SubscriptionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

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
    end
  end

  def update
    subscription = Subscription.find(params[:id])

    if subscription.update(subscription_params)
      if subscription.status == false
        render json: { success: "Subscription is now inactive" }, status: :accepted
      else
        render json: { success: "Subscription is now active" }, status: :accepted
      end
    else
      render json: { error: "FAIL: invalid params" }, status: :unprocessable_entity
    end
  end

  def destroy
    subscription = Subscription.find(params[:id])
    if subscription.destroy
      render json: { success: "Subscription deleted successfully" }, status: :ok
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :tea_id)
  end

  def not_found
    render json: { error: "Search query not found" }, status: :not_found
  end
end
