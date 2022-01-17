class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  before_validation :set_nil_for_false # nil and FALSE are considered the same

  validates :body, presence: true
  validates_inclusion_of :is_best, in: [true, false, nil] 

  # use custom sorting to sort answers wit FALSE or nil after TRUE `is_best` value
  scope :sort_by_best, -> { order(Arel.sql('case when is_best then 1 when is_best is null then 2 else 3 end')) }

  def make_best
    transaction do
      question.answers.where(is_best: true).update_all(is_best: false)
      update!(is_best: true)
    end
  end

  private 

  def set_nil_for_false
    @is_best = nil unless @is_best
  end
end
