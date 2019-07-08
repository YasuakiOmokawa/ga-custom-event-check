class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :user_id }

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :tasks
  has_many :notes

  def late?
    due_on.in_time_zone < Date.current.in_time_zone
  end
end
