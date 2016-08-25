class Lesson < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :user
  belongs_to :category

  has_many :results, dependent: :destroy

  before_create :build_result
  after_create :send_remind_email
  after_update :cancel_remind_email, :create_public_activty,
    :send_complete_email

  validates :category, presence: true
  validate :category_word_count

  scope :by_user, -> (user) {where user_id: user.id}
  scope :recent, -> (time) {where("lessons.created_at > ?", time) if time.present?}
  scope :of_category, -> category_id do
    where category_id: category_id if category_id.present?
  end

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

  def cancel_remind_email
    if self.is_completed?
      Delayed::Job.find_by(target_id: self.id).delete
    end
  end

  def send_remind_email
    LessonMailer.delay(run_at: Settings.email_delay.seconds.from_now,
      target_id: self.id).remind_email self.user, self
  end
  def send_complete_email
    LessonWorker.perform_async self.user, self
  end
  def create_public_activty
    if self.is_completed?
      self.create_activity :create, owner: self.user
    end
  end
end
