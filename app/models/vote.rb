class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum degree: { like: 1, dislike: -1 }

  validates :degree, presence: true

  def like
    self.degree = 1
  end

  def dislike
    self.degree = -1
  end
end
