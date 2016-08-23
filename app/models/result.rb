class Result < ActiveRecord::Base

  belongs_to :lesson
  belongs_to :word
  belongs_to :answers

  query = "INNER JOIN answers ON results.word_id =
    answers.word_id AND results.answer_id = answers.id"
  scope :in_lesson, -> (lesson) {where lesson_id: lesson.id}
  scope :correct, -> {joins(query).merge(Answer.correct)}

  def correct_answer
    answer = self.word.answers.find{|a| a.is_correct}
  end

  def is_correct_answer?
    if self.answer_id
      Answer.find_by(id: self.answer_id).is_correct?
    end
  end

  def user_answer
    Answer.find_by id: self.answer_id
  end
end
