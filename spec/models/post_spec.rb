require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'create new post' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:body)}
    it { should validate_presence_of(:user_id)}

    it { should belong_to(:user) }
    it { should have_many(:comments) }
  end
end
