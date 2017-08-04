require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_numericality_of(:user_id).only_integer }
  it { should validate_numericality_of(:post_id).only_integer }
  it { should validate_inclusion_of(:score).in_array [-1, 1] }
  #it { should validate_uniqueness_of(:user_id).scoped_to(:post_id) }

  it { should belong_to(:post) }
  it { should belong_to(:user) }
end
