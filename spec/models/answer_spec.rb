require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).required }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
end
