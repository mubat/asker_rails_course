class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates_inclusion_of :is_best, in: [true, false, nil]
end
