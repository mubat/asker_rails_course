class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates_inclusion_of :is_best, in: [true, false, nil]

  def make_best
    transaction do
      question.best_answer.update(is_best: false) if question.best_answer
      update(is_best: true) 
    end
  end
end
