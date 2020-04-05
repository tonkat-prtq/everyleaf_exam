10.times do |n|
  User.create!(
    name: "TEST_USER#{n + 1}",
    email: "tester#{n + 1}@test.com",
    password: "password",
    password_confirmation: "password"
  )
end

100.times do |n|
  Task.create!(
    name: "TESTASK#{n + 1}",
    content: "tes#{n + 1}",
    status: rand(3),
    priority: rand(3),
    deadline: Time.current,
    user_id: rand(1..10)
  )
end

Label.create!(name: "勉強")
Label.create!(name: "料理")
Label.create!(name: "仕事")

tasks = Task.all

tasks.each do |task|
  Labeling.create!(label_id: rand(1..3), task_id: task.id)
end

User.create!(
  [
    {
      name: "admin1",
      email: "admin1@test.com",
      password: "password",
      password_confirmation: "password",
      admin: true
    },

    {
      name: "admin2",
      email: "admin2@test.com",
      password: "password",
      password_confirmation: "password",
      admin: true
    }
  ]
)