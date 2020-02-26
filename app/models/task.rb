class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: {maximum: 140}
  validates :content, presence: true
  validates :content, length: {maximum: 300}
end
