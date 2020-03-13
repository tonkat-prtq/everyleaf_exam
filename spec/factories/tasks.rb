FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "TEST_TASK#{n}"}
    sequence(:content) { |n| "TEST_CONTENT#{n}"}
    sequence(:status) { "未着手" }
    sequence(:deadline) { Time.current }
  end

  factory :new_task, class: Task do # 存在しないclass名の名前をつける場合、optionで「このclassのテストデータにしてください」と指定
    sequence(:name) { "new_test_task" }
    sequence(:content) { "new_content" }
    sequence(:status) { "着手" }
    sequence(:deadline) { Time.now + 1.hours }
    sequence(:created_at) { Time.now + 1.hours}
  end

  factory :completed_task, class: Task do
    sequence(:name) { "completed_task" }
    sequence(:content) { "completed!"}
    sequence(:status) { "完了" }
    sequence(:deadline) { Time.now - 1.days }
    sequence(:created_at) { Time.now - 2.days }
  end
end
