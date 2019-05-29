class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, presence: true

  def set_best
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer.update!(best: false) if best_answer
      update!(best: true)
    end
  end
end
