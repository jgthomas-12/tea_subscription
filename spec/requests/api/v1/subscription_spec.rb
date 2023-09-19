require "rails_helper"

RSpec.describe "API V1 Subscription request", type: :request do
  context "POST /api/v1/customers/:id/subscriptions" do
    context "happy path" do

      let!(:customer1) { FactoryBot.create(:customer) }
      let!(:tea1) { FactoryBot.create(:tea) }

      it "adds/subscribes a customer and tea to a subscription" do
        subscription_params = FactoryBot.attributes_for(:subscription, tea_id: tea1.id)

        post "/api/v1/customers/#{customer1.id}/subscriptions", params: { subscription: subscription_params }

        expect(response).to be_successful
        expect(response.status).to eq(201)

        new_subscription = JSON.parse(response.body, symbolize_names: true)

        expect(new_subscription).to be_a(Hash)
        expect(new_subscription).to have_key(:success)
        expect(new_subscription).to have_value("Subscription added successfully")
      end
    end
  end
end
