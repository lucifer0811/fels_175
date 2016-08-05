class Category < ActiveRecord::Base
  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy
end
