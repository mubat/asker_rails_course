class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  has_many_attached :files

  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true

  def best_answer
    answers.where(is_best: true).first
  end
end
