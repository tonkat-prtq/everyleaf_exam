class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: {maximum: 40}
  validates :content, presence: true
  validates :content, length: {maximum: 300}
  validates :deadline, presence: true
  validates :status, presence: true
  validates :status, length: {maximum: 10}

  def self.search(name, status)
    if name.empty? && status.empty?
      all
    elsif name.empty? && status
      where(status: status)
    elsif name && status.empty?
      where('name LIKE ?', "%#{name}%")
    else
      where("name LIKE ? and status = ?", "%#{name}%", "#{status}")
    end
  end

  scope :desc, -> {order(created_at: :desc)}

end
