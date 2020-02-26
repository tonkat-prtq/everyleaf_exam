FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "TEST_TASK#{n}"}
    sequence(:content) { |n| "TEST_CONTENT#{n}"}
  end
end
