FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "someguy_#{n}" }
    email { "#{name}@example.com" }
    after(:build) { |u| u.password_confirmation = u.password = '123456' }
  end
end
