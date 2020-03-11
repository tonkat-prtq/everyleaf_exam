class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: {maximum: 40}
  validates :content, presence: true
  validates :content, length: {maximum: 300}
  validates :deadline, presence: true
  validates :status, presence: true
  validates :status, length: {maximum: 10}

  # def self.search(name, status)
  #   if name.empty? && status.empty?
  #     all
  #   elsif name.empty? && status
  #     where(status: status)
  #   elsif name && status.empty?
  #     where('name LIKE ?', "%#{name}%")
  #   else
  #     where("name LIKE ? and status = ?", "%#{name}%", "#{status}")
  #   end
  # end

  scope :default_order, -> { order(created_at: :desc) } # 作成日を降順に並べるscopeの名前を変更し分かりやすく
  scope :sort_deadline, -> { order(deadline: :desc) }
  scope :search_with_name, -> (name) {
    return if name.blank?
    where('name LIKE ?', "%#{name}%")
  }
  scope :search_with_status, -> (status) {
    return if status.blank?
    where(status: status)
  }

end
