class Task < ApplicationRecord
  belongs_to :users
  validates :name, presence: true
  validates :name, length: {maximum: 40}
  validates :content, presence: true
  validates :content, length: {maximum: 300}
  validates :deadline, presence: true
  enum status: [:waiting, :working, :completed]
  enum priority: [:high, :medium, :low]

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

  def self.human_attribute_enum_value(attr_name, value)
    human_attribute_name("#{attr_name}.#{value}")
  end

  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_value(attr_name, self[attr_name])
  end

  def self.enum_options_for_select(attr_name)
    self.send(attr_name.to_s.pluralize).map {|k, _| [self.human_attribute_enum_value(attr_name, k), k]}.to_h
  end
end
