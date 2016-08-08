class Result < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :word
  belongs_to :answers
end
