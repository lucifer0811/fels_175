class Word < ActiveRecord::Base

  QUERRY_WORD_TRUE_LEARNT = "id in (SELECT DISTINCT ls.word_id FROM lesson_words ls
    INNER JOIN lessons l ON l.id = ls.lesson_id
    INNER JOIN word_answers wa ON ls.word_id = wa.word_id AND ls.word_answer_id = wa.id
    WHERE wa.is_correct = 't' AND l.user_id = :user_id AND l.is_completed = 't')"

  QUERRY_WORD_WRONG_LEARNT = "id in (SELECT DISTINCT ls.word_id FROM
    lesson_words ls JOIN lessons l ON ls.lesson_id = l.id
    WHERE l.user_id = :user_id AND l.is_completed = 't'
    EXCEPT
    SELECT DISTINCT ls.word_id FROM lesson_words ls
    INNER JOIN lessons l ON l.id = ls.lesson_id
    INNER JOIN word_answers wa ON ls.word_id = wa.word_id AND ls.word_answer_id = wa.id
    WHERE wa.is_correct = 't' AND l.user_id = :user_id AND l.is_completed = 't')"

  QUERRY_WORD_LEARNT = "id in (SELECT DISTINCT ls.word_id FROM lesson_words ls
    INNER JOIN lessons l ON ls.lesson_id = l.id
    WHERE l.user_id = :user_id AND l.is_completed = 't')"

  QUERRY_WORD_NOT_YET = "id not in (SELECT DISTINCT ls.word_id FROM
    lesson_words ls JOIN lessons l ON ls.lesson_id = l.id
    WHERE l.user_id = :user_id AND l.is_completed = 't')"

  scope :random, -> {order "RANDOM()"}
  scope :in_category, -> category_id do
    where category_id: category_id if category_id.present?
  end

  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :content, presence: true, uniqueness: true

  accepts_nested_attributes_for :answers, allow_destroy: true


  def correct_answer
    self.answers.correct.first
  end
end
