require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).required }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
 
 # Rails validator `validate_inclusion_of` can't check nil. Watch validator description
  it { should allow_value(nil).for(:is_best) } 
  it { should allow_value(true).for(:is_best) }
  it { should allow_value(false).for(:is_best) }

  it 'have one attached file' do
    expect(Answer.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end
end
