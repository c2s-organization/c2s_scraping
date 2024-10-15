FactoryBot.define do
  factory :car do
    make { Faker::Vehicle.make }
    model { Faker::Vehicle.model }
    year { "#{rand(2015..2023)}" }
    price { Faker::Commerce.price(range: 10000..50000).to_s }
  end
end
