class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  before_validation { email.downcase! }
  validates :email, presence: true, length: { maximum: 255 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true
end
