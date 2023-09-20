require "rails_helper"

RSpec.describe "API V1 Subscription request", type: :request do
  describe "POST /api/v1/customers/:id/subscriptions" do

    let!(:customer1) { FactoryBot.create(:customer) }
    let!(:tea1) { FactoryBot.create(:tea) }

    context "happy path" do
      it "adds/subscribes a customer and tea to a subscription" do
        expect(customer1.subscriptions.count).to eq(0)

        subscription_params = FactoryBot.attributes_for(:subscription, tea_id: tea1.id)

        post api_v1_customer_subscriptions_path(customer1), params: { subscription: subscription_params }

        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(customer1.subscriptions.count).to eq(1)
        expect(customer1.subscriptions.first.tea_id).to eq(tea1.id)

        new_subscription = JSON.parse(response.body, symbolize_names: true)

        expect(new_subscription).to be_a(Hash)
        expect(new_subscription).to have_key(:success)
        expect(new_subscription).to have_value("Subscription added successfully")
      end
    end

    context "sad path" do
      it "returns an error if a tea_id is invalid" do
        subscription_params = FactoryBot.attributes_for(:subscription, tea_id: nil)

        post api_v1_customer_subscriptions_path(customer1), params: { subscription: subscription_params }

        expect(response).not_to be_successful
        expect(response.status).to eq(422)

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(error_response).to be_a(Hash)
        expect(error_response).to have_key(:error)
        expect(error_response[:error]).to include("Invalid parameters")
      end

      it "returns an error if parameter values are invalid" do
        subscription_params = FactoryBot.attributes_for(:subscription, title: nil, price: nil, frequency: nil,  tea_id: tea1.id)

        post api_v1_customer_subscriptions_path(customer1), params: { customer_id: customer1.id, subscription: subscription_params }

        expect(response).not_to be_successful
        expect(response.status).to eq(422)
        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(error_response).to be_a(Hash)
        expect(error_response).to have_key(:error)
        expect(error_response[:error]).to include("Invalid parameters")
      end

      # it "returns an error if a customer_id is invalid" do
      # expect{ Customer.find(customer1.id) }.to raise_error(ActiveRecord::RecordNotFound)

      #   customer_id = 999
      #   subscription_params = FactoryBot.attributes_for(:subscription, tea_id: tea1.id)

      #   post "/api/v1/customers/#{customer_id}/subscriptions", params: { subscription: subscription_params }

      #   expect(response).not_to be_successful
      #   expect(response.status).to eq(422)

      #   error_response = JSON.parse(response.body, symbolize_names: true)

      #   expect(error_response).to be_a(Hash)
      #   expect(error_response).to have_key(:error)
      #   require 'pry'; binding.pry
      #   expect(error_response[:error]).to include("Customer must exist")
      # end
    end
  end

  describe "DELETE /api/v1/customers/:id/subscriptions" do

    let!(:customer1) { FactoryBot.create(:customer) }
    let!(:tea1) { FactoryBot.create(:tea) }
    let!(:subscription1) { FactoryBot.create(:subscription, customer: customer1, tea: tea1) }

    context "happy path" do
      it "successfully deletes a customer's subscription" do
        expect(customer1.subscriptions.count).to eq(1)

        delete api_v1_customer_subscription_path(customer1, subscription1)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(customer1.subscriptions.count).to eq(0)
        expect{ Subscription.find(subscription1.id) }.to raise_error(ActiveRecord::RecordNotFound)

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(error_response).to be_a(Hash)
        expect(error_response).to have_key(:success)
        expect(error_response).to have_value("Subscription deleted successfully")
      end
    end

    # sad path - how can you make a subscription that can't be deleted? Add dependencies? 
  end
end
