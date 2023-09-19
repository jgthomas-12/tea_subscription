require "rails_helper"

RSpec.describe Subscription, type: :model do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :price }
    it { should validate_presence_of :frequency }
    it { should validate_presence_of(:status).allow_nil }

  end

  describe "associations" do
    it { should belong_to :tea}
    it { should belong_to :customer}
  end
end