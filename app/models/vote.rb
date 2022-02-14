class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  def like
    self.degree = 1
  end

  def dislike
    self.degree = -1
  end
end
