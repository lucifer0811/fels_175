class Category < ActiveRecord::Base
  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
