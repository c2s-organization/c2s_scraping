FactoryBot.define do
  factory :scrape_car do
    task_id { 123 }
    url { 'https://example.com/car-listing' }
  end
end
