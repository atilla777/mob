require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_post) { create(:post, user_id: user.id) }
  let(:comment_attributes) { attributes_for(:comment,
                                            user_id: user.id,
                                            post_id: user_post.id) }
  let(:comment) { create(:comment, comment_attributes) }
  let(:create_comment) do
    post :create, params: { comment: comment_attributes,
                            post_id: user_post.id,
                            format: :js }
  end
  let(:user_comment) { Comment.where(user_id: user.id,
                                     post_id: user_post.id).first }
  let(:update_comment) do
    patch :update, params: { comment: { body: 'updated by user!' },
                             post_id: user_post.id,
                             id: user_comment.id,
                             format: :js }
  end
  let(:delete_comment) do
    delete :destroy, params: { post_id: user_post.id,
                               id: user_comment.id,
                               format: :js }
  end

  context 'registered user ' do
    it 'can create comment' do
      sign_in user
      expect { create_comment }.to change { Comment.count }
      expect(response).to render_template(:create)
    end

    it 'can edit comment' do
      sign_in user
      create_comment
      update_comment

      expect(response).to render_template(:update)
    end

    it 'can delete comment' do
      sign_in user
      create_comment
      expect { delete_comment }.to change { Comment.count }
      expect(response).to have_http_status(:success)
    end
  end

  context 'anonymouse' do
    it 'can`t create comment' do
      expect { create_comment }.to_not change { Comment.count }
      expect(response).to have_http_status(401)
    end
    it 'can`t update comment' do
      comment
      update_comment

      expect(response).to have_http_status(401)
    end
    it 'can`t delete comment' do
      comment
      delete_comment

      expect { delete_comment }.to_not change { Comment.count }
      expect(response).to have_http_status(401)
    end
  end

end
