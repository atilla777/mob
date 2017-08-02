require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user_id: user.id) }
  let(:post_attributes) { attributes_for(:post, user_id: user.id) }
  let(:post_create) { post :create, params: { post: post_attributes }, js: true }
  context 'registered user ' do
    it 'can create comment', js: true do
      expect{ create_post }.to change{ Post.count }

      expect(response).to render_template(:create)
    end
  end
end
