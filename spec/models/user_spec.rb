require 'rails_helper'

RSpec.describe User, type: :model do
  context 'registration' do
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:password).is_at_least(6) }

    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
  end
end
