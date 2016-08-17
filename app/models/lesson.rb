class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy
  scope :recent, -> (time) {where("reviews.created_at > ?", time) if time.present?}
end
