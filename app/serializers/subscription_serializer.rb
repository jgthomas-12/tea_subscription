class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :status, :frequency

  def price
    object.price.to_f
  end
end
