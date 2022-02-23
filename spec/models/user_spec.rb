require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:rewards) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'check #author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question) }

    it 'passed if user is author of the question' do
      expect(user).to be_author_of(question)
    end

    it 'failed if user is author of the other question' do
      expect(user).to_not be_author_of(other_question)
    end

  end
end
