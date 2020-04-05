class Labeling < ApplicationRecord
  belongs_to :task
  belongs_to :label
  validates :id, uniqueness: { scope: [:task_id, :label_id] }
end