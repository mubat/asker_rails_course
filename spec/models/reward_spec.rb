require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional(true) }

  it { should validate_presence_of :name }

  it { should validate_attached_of(:image) }
  it { should validate_content_type_of(:image).allowing('image/jpg', 'image/jpeg', 'image/gif', 'image/png') }

  it 'have one attached file' do
    expect(subject.image).to be_an_instance_of ActiveStorage::Attached::One
  end
end
