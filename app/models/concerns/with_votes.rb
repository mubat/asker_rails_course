module WithVotes
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def like(user)
    register_vote(user, :like)
  end

  def dislike(user)
    register_vote(user, :dislike)
  end

  def vote_of(user)
    votes.where(user: user).take
  end

  def rating
    votes.sum(:degree)
  end

  private

  def register_vote(user, status)
    vote = votes.find_or_create_by(user: user)
    vote.send(status)
    vote.save
    vote
  end
end
