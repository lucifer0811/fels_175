class Lesson < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :user
  belongs_to :category

  has_many :results, dependent: :destroy

  before_create :build_result

  validates :category, presence: true
  validate :category_word_count

  scope :by_user, -> (user) {where user_id: user.id}
  scope :recent, -> (time) {where("lessons.created_at > ?", time) if time.present?}

  accepts_nested_attributes_for :results,
    reject_if: proc {|attributes| attributes[:answer_id].blank?}

  def count_correct_answers
    if self.is_completed?
      Result.correct.in_lesson(self).count
    end
  end

  def build_result
    Word.in_category(self.category.id).random.limit(Settings.word.minimum)
      .each do |word|
      self.results.build word_id: word.id
    end
  end

  private
  def category_word_count
    unless self.category && self.category.words.count >= Settings.word.minimum
      self.errors.add :category,
        I18n.t("lesson.errors.not_enough_words")
    end
  end
end
