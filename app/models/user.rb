class User < ApplicationRecord
  before_destroy :admin_exist_check
  before_update :admin_update_exist

  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

  before_validation { email.downcase! }
  validates :email, presence: true, length: { maximum: 255 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def admin_exist_check
    if User.where(admin: true).count <= 1 && self.admin == true
      throw(:abort)
    end
  end

  def admin_update_exist
    if User.where(admin: true).count == 1 && self.admin == false
      throw(:abort)
    end
  end

end
