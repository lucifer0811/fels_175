class Word < ActiveRecord::Base

  QUERRY_WORD_TRUE_LEARNT = "id in (SELECT DISTINCT ls.word_id FROM results ls
    INNER JOIN lessons l ON l.id = ls.lesson_id
    INNER JOIN answers wa ON ls.word_id = wa.word_id AND ls.answer_id = wa.id
    WHERE wa.is_correct = 't' AND l.user_id = :user_id AND l.is_completed = 't')"

  QUERRY_WORD_WRONG_LEARNT = "id in (SELECT DISTINCT ls.word_id FROM
    results ls JOIN lessons l ON ls.lesson_id = l.id
    WHERE l.user_id = :user_id AND l.is_completed = 't'
    EXCEPT
    SELECT DISTINCT ls.word_id FROM results ls
    INNER JOIN lessons l ON l.id = ls.lesson_id
    INNER JOIN answers wa ON ls.word_id = wa.word_id AND ls.answer_id = wa.id
    WHERE wa.is_correct = 't' AND l.user_id = :user_id AND l.is_completed = 't')"

  QUERRY_WORD_LEARNT = "id in (SELECT DISTINCT ls.word_id FROM results ls
    INNER JOIN lessons l ON ls.lesson_id = l.id
    WHERE l.user_id = :user_id AND l.is_completed = 't')"

  QUERRY_WORD_NOT_YET = "id not in (SELECT DISTINCT ls.word_id FROM
    results ls JOIN lessons l ON ls.lesson_id = l.id
    WHERE l.user_id = :user_id AND l.is_completed = 't')"

  scope :random, -> {order "RANDOM()"}
  scope :in_category, -> category_id do
    where category_id: category_id if category_id.present?
  end
  scope :show_all, -> user_id {}
  scope :learned, -> user_id {where QUERRY_WORD_LEARNT, user_id: user_id}
  scope :not_learned, -> user_id {where QUERRY_WORD_NOT_YET, user_id: user_id}

  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :content, presence: true, uniqueness: true
  validate :validate_answer_unique, :validate_answer_correct
  accepts_nested_attributes_for :answers, allow_destroy: true

  def correct_answer
    self.answers.correct.first
  end

  private
  def validate_answer_unique
    if self.answers.to_a.uniq {|answer| answer.content}.count >= 4
      return true
    else
      self.errors.add :word, I18n.t("views.answer.validate.uniqueness")
      return false
    end
  end
  def validate_answer_correct
    if self.answers.to_a.select{|a| a.is_correct}.count != 1
      self.errors.add :word, I18n.t("views.answer.validate.correct_count")
      return false
    else
      return true
    end
  end
end
