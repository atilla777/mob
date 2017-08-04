require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  context 'other user' do
    let(:user) { create(:user) }
    let(:user_post) { create(:post, user_id: user.id) }
    let(:other_user) { create(:user) }
    let(:set_like) do
      post :create, params: { vote: {score: 1}, post_id: user_post.id }, format: :js
    end
    let(:set_like) do
      post :create, params: { vote: {score: -1}, post_id: user_post.id }, format: :js
    end

    it 'can like post' do
      user_post
      sign_in other_user

      expect { set_like }.to change { Vote.count }.by(1)
      expect(response).to have_http_status(200)
    end

    it 'can dislike post' do
      user_post
      sign_in other_user

      expect { set_dislike }.to change { Vote.count }.by(1)
      expect(response).to have_http_status(200)
    end
  end

end
