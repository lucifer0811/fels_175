class Word < ActiveRecord::Base
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy
  validates :content, presence: true, uniqueness: true

  accepts_nested_attributes_for :answers, allow_destroy: true
end
