FactoryBot.define do
  factory :tea do
    title { Faker::Kpop.i_groups }
    description { Faker::Books::Dune.saying }
    temperature { rand(1..2000) }
    brew_time { rand(1..100) }
  end
end