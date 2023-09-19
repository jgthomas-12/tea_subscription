class Subscription < ApplicationRecord
  validates :title, presence: true
  validates :price, presence: true
  validates :status, inclusion: { in: [true, false], allow_nil: true }
  validates :frequency, presence: true

  belongs_to :tea
  belongs_to :customer

  enum frequency: %w[weekly monthly annually]
end