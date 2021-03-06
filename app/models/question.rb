class Question < ApplicationRecord
  include WithVotes
  
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true

  def best_answer
    answers.where(is_best: true).first
  end
end
