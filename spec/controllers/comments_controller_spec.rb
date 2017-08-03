require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_post) { create(:post, user_id: user.id) }
  let(:comment_attributes) { attributes_for(:comment, user_id: user.id, post_id: user_post.id) }
  let(:add_comment) do
    post :create, params: {comment: comment_attributes, post_id: user_post.id, format: :js}
  end

  context 'registered user ' do
    it 'can create comment' do
      sign_in user
      expect { add_comment }.to change { Comment.count }
      expect(response).to render_template(:create)
    end
  end

  context 'anonymouse' do
    it 'can`t create comment' do
      expect { add_comment }.to_not change { Comment.count }
      expect(response).to have_http_status(401)
    end
  end
end
