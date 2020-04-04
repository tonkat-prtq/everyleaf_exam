FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "TEST_TASK#{n}"}
    sequence(:content) { |n| "TEST_CONTENT#{n}"}
    sequence(:status) { :waiting }
    sequence(:priority) { :high }
    sequence(:deadline) { Time.current }
    user

    after(:create) do |task|
      create(:labeling, task: task, label: create(:label))
    end
  end

  factory :new_task, class: Task do # 存在しないclass名の名前をつける場合、optionで「このclassのテストデータにしてください」と指定
    sequence(:name) { "new_test_task" }
    sequence(:content) { "new_content" }
    sequence(:status) { :working }
    sequence(:priority) { :medium }
    sequence(:deadline) { Time.now + 1.hours }
    sequence(:created_at) { Time.now + 1.hours}
    user
  end

  factory :completed_task, class: Task do
    sequence(:name) { "completed_task" }
    sequence(:content) { "completed!"}
    sequence(:status) { :completed }
    sequence(:priority) { :low }
    sequence(:deadline) { Time.now - 1.days }
    sequence(:created_at) { Time.now - 2.days }
    user
  end
end
