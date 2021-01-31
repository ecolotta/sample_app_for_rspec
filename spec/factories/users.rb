FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    
  end
end
