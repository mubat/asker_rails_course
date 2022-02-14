require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :degree }

  it { should define_enum_for(:degree).with_values({ like: 1, dislike: -1 }) }
end
