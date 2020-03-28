FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "sample_user#{n}" }
    sequence(:email) { |n| "sample#{n}@example.com" }
    sequence(:password) { "password" }
    sequence(:admin) { false }
  end

  factory :admin_user, class: User do
    sequence(:name) { "admin#" }
    sequence(:email) { "admin@example.com" }
    sequence(:password) { "password" }
    sequence(:admin) { true }
  end
end