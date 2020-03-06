FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "TEST_TASK#{n}"}
    sequence(:content) { |n| "TEST_CONTENT#{n}"}
    sequence(:deadline) { Time.current }
  end

  factory :new_task, class: Task do # 存在しないclass名の名前をつける場合、optionで「このclassのテストデータにしてください」と指定
    sequence(:name) { "new_test_task" }
    sequence(:content) { "new_content" }
    sequence(:deadline) { Time.now + 1.hours }
    sequence(:created_at) { Time.now + 1.hours}
  end
end
