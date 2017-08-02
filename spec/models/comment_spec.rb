require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_numericality_of(:post_id).only_integer }
  it { should validate_numericality_of(:user_id).only_integer }
  it { should validate_presence_of(:body) }
  it { should belong_to(:user) }
end
