class Result < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :lesson
  belongs_to :word
  belongs_to :answers
end
