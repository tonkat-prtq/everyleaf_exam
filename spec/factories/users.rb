FactoryBot.define do
  factory :user do
    sequence(:id) { 1 }
    sequence(:name) { "sample_user1" }
    sequence(:email) { "sample1@example.com" }
    sequence(:password) { "password" }
    sequence(:admin) { false }
  end

  factory :admin_user, class: User do
    sequence(:id) { 2 }
    sequence(:name) { "admin" }
    sequence(:email) { "admin@example.com" }
    sequence(:password) { "password" }
    sequence(:admin) { true }
  end
end