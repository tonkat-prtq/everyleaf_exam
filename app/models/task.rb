class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: {maximum: 40}
  validates :content, presence: true
  validates :content, length: {maximum: 300}
  validates :deadline, presence: true
  validates :status, presence: true
  validates :status, length: {maximum: 10}
end
