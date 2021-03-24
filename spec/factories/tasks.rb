FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "test#{n}" }
    content { "test" }
    status { :todo }
    association :user
    Task.statuses.keys.each do |status|
      trait :"#{status}" do
        status { status }
      end
    end
  end
end
