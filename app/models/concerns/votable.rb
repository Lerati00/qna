module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voted?(user)
    votes.exists?(user: user)
  end

  def vote(user, type)
    return if voted?(user)
    votes.create!(user: user, score: type ? 1 : -1)
  end

  def cancel_vote(user)
    return unless voted?(user)
    transaction { votes.find_by(user: user).destroy }
  end

  def score
    votes.sum(:score)
  end
end
