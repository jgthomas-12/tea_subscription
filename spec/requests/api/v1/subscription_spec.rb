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
      # # expect{ Customer.find(customer1.id) }.to raise_error(ActiveRecord::RecordNotFound)

      #   customer_id = 999
      #   subscription_params = FactoryBot.attributes_for(:subscription, tea_id: tea1.id)

      #   post "/api/v1/customers/#{customer_id}/subscriptions", params: { subscription: subscription_params }

      #   expect(response).not_to be_successful
      #   expect(response.status).to eq(422)

      #   error_response = JSON.parse(response.body, symbolize_names: true)

      #   expect(error_response).to be_a(Hash)
      #   expect(error_response).to have_key(:error)
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

  describe "GET /api/v1/customers/:id/subscriptions" do

    let!(:customer1) { FactoryBot.create(:customer) }
    let!(:tea1) { FactoryBot.create(:tea) }
    let!(:tea2) { FactoryBot.create(:tea) }
    let!(:subscription1) { FactoryBot.create(:subscription, status: true, customer: customer1, tea: tea1) }
    let!(:subscription2) { FactoryBot.create(:subscription, status: false,  customer: customer1, tea: tea2) }
    let!(:subscription3) { FactoryBot.create(:subscription, status: true,  customer: customer1, tea: tea2) }

    context "happy path" do
      it "returns a JSON object with all of a customer's subscriptions both active and inactive" do

        get api_v1_customer_subscriptions_path(customer1)

        expect(response).to be_successful
        expect(response.status).to eq(200)

        subscriptions = JSON.parse(response.body, symbolize_names: true)
        expect(subscriptions[:data].count).to eq(3)

        expect(subscriptions).to be_a(Hash)
        expect(subscriptions).to have_key(:data)
        expect(subscriptions[:data]).to be_an(Array)
        expect(subscriptions[:data].first).to be_a(Hash)
        expect(subscriptions[:data].first).to have_key(:id)
        expect(subscriptions[:data].first).to have_key(:type)
        expect(subscriptions[:data].first).to have_key(:attributes)

        expect(subscriptions[:data].first[:id]).to be_a(String)
        expect(subscriptions[:data].first[:type]).to be_a(String)
        expect(subscriptions[:data].first[:attributes]).to be_a(Hash)

        expect(subscriptions[:data].first[:attributes]).to have_key(:title)
        expect(subscriptions[:data].first[:attributes]).to have_key(:price)
        expect(subscriptions[:data].first[:attributes]).to have_key(:status)
        expect(subscriptions[:data].first[:attributes]).to have_key(:frequency)

        expect(subscriptions[:data].first[:attributes][:title]).to be_a(String)
        expect(subscriptions[:data].first[:attributes][:price]).to be_a(Float)
        expect(subscriptions[:data].first[:attributes][:status]).to be_instance_of(TrueClass).or be_instance_of(FalseClass)
        expect(subscriptions[:data].first[:attributes][:frequency]).to be_a(String)
      end
    end
  end
end
