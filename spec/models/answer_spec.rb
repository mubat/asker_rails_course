require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).required }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
 
  it { should allow_value(nil).for(:is_best) } # Rails validator `validate_inclusion_of` can't check nil. Watch validator description
  it { should validate_inclusion_of(:is_best).in_array([true, false]) }
end
