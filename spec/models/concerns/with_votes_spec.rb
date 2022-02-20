require 'rails_helper'

describe 'WithVotes' do
  with_model :TestVotable do
    table do |t|
      t.references :user, null: false, foreign_key: true
    end

    model do
      include WithVotes
      belongs_to :user
    end
  end

  let(:user) { create(:user) }

  it 'has the module' do
    expect(TestVotable.include?(WithVotes)).to eq true
  end

  it 'can likes and dislikes itself' do
    expect(TestVotable.method_defined?(:like)).to be_truthy
    expect(TestVotable.method_defined?(:dislike)).to be_truthy
  end

  context 'with rating' do
    let!(:votable) { TestVotable.create!(user: create(:user)) }

    before do
      create_list(:vote, 8, votable: votable, degree: :like)
      create_list(:vote, 5, votable: votable, degree: :dislike)
    end

    it "has 'rating' method" do
      expect(TestVotable.method_defined?(:rating)).to be_truthy
    end

    it "can calculate rating" do
      expect(votable.rating).to eq 3
    end

    it 'change rating after like' do
      user2 = create(:user)
      expect { votable.dislike(user2) }.to change { votable.rating }.by(-1)
    end
  end

end
