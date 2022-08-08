FactoryBot.define do
  factory :event do
    association :user

    title { 'Event 1' }
    address { 'Moscow' }
    datetime { Time.now }
  end
end
