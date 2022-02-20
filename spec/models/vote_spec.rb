require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :degree }

  it { should define_enum_for(:degree).with_values({ like: 1, dislike: -1 }) }

  it {
    user = create(:user)
    answer = create(:answer, user: user)
    vote = answer.votes.new(user: user)
    expect(vote.validate).to be_falsey
    expect(vote.errors.full_messages_for(:user)).to include("User can't vote on his Answer")
  }
end
