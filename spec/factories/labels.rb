FactoryBot.define do
  factory :label do
    id { 1 }
    name { "勉強" }
  end

  factory :label2, class: Label do
    id { 2 }
    name { "料理" }
  end
end
