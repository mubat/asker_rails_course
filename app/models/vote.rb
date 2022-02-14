class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum degree: { like: 1, dislike: -1 }

  validates :degree, presence: true
  validate :validate_comparison_user

  def like
    self.degree = 1
  end

  def dislike
    self.degree = -1
  end

  private

  def validate_comparison_user
    errors.add(:user, "can't vote on his Answer") if user && user == votable.user
  end
end
