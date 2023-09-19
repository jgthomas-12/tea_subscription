FactoryBot.define do
  factory :subscription do
    title { Faker::Kpop.i_groups }
    price { Faker::Number.decimal(l_digits: 2) }
    status { [true, false].sample }
    frequency { %w[weekly monthly annually].sample }
  end
end