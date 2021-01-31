FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:content) { |n| "Content #{n}" }
    status { :todo }
    association :user
  end
end
