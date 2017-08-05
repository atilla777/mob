require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_post) { create(:post, user_id: user.id) }
  let(:comment_attributes) { attributes_for(:comment,
                                            user_id: user.id,
                                            post_id: user_post.id) }

  let(:create_comment) do
    post :create, params: { comment: comment_attributes,
                            post_id: user_post.id,
                            format: :js }
  end

  let(:user_comment) { create(:comment, comment_attributes) }

  let(:update_comment) do
    patch :update, params: { comment: { body: 'Comment updated!' },
                             post_id: user_post.id,
                             id: user_comment.id,
                             format: :js }
  end

  let(:delete_comment) do
    delete :destroy, params: { post_id: user_post.id,
                               id: user_comment.id,
                               format: :js }
  end

  context 'user' do
    it 'can create comment' do
      sign_in user

      expect { create_comment }.to change { Comment.count }
      expect(response).to render_template(:create)
    end

    it 'can edit his comment' do
      sign_in user
      update_comment

      expect(response).to render_template(:update)
      expect(assigns(:comment).body).to eq('Comment updated!')
    end

    it 'can delete his comment' do
      sign_in user
      user_comment
      expect { delete_comment }.to change { Comment.count }
      expect(response).to have_http_status(:success)
    end
  end

  context 'other user' do
    it 'can`t update comment' do
      sign_in other_user
      user_comment
      update_comment

      expect(response).to have_http_status(403)
      expect(user_comment.body).to_not eq('Comment updated!')
    end

    it 'can`t delete comment' do
      sign_in other_user
      user_comment

      expect { delete_comment }.to_not change { Comment.count }
      expect(response).to have_http_status(403)
    end
  end

  context 'anonymouse' do
    it 'can`t create comment' do
      expect { create_comment }.to_not change { Comment.count }
      expect(response).to have_http_status(401)
    end

    it 'can`t update comment' do
      user_comment
      update_comment

      expect(response).to have_http_status(401)
      expect(user_comment.body).to_not eq('Comment updated!')
    end

    it 'can`t delete comment' do
      user_comment

      expect { delete_comment }.to_not change { Comment.count }
      expect(response).to have_http_status(401)
    end
  end
end
