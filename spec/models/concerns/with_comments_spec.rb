require 'rails_helper'

describe 'WithComments' do
  with_model :TestCommentable do
    table do |t|
      t.references :user, null: false, foreign_key: true
    end

    model do
      include WithComments
      belongs_to :user
    end
  end

  let(:user) { create(:user) }

  it 'has the module' do
    expect(TestCommentable.include?(WithComments)).to eq true
  end

  it 'has polymorphic relation called Commentable ' do
    expect(TestCommentable.new).to have_many(:comments)
  end

end
