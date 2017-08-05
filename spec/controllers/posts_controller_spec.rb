require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:writer) { create(:user, writer: true) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:posts) { create_list(:post, 2, user_id: writer.id) }
  let(:writer_post) { posts.first }
  let(:create_post) { post :create, params: { post: attributes_for(:post, user_id: user.id) } }
  let(:update_post) { put :update, params: { id: writer_post.id, post: { name: 'Post updated!'}} }
  let(:delete_post) { delete :destroy, params: {id: writer_post.id } }

  context 'anonymouse user' do
    it 'can view posts' do
      get :index

      expect(response).to render_template :index
      expect(assigns(:posts)).to  match_array posts
    end

    it 'can view post' do
      get :show, params: { id: writer_post.id }

      expect(response).to render_template :show
    end

    it 'can`t start create post' do
      get :new

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'can`t create post' do
      expect { create_post }.to_not change { Post.count }
      expect(response).to redirect_to(new_user_session_url)

    end

    it 'can`t start update post' do
      get :edit, params: {id: writer_post.id}

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'can`t update post' do
      update_post

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'can`t delete post' do
      posts
      expect { delete_post }.to_not change { Post.count }
      expect(response).to redirect_to(new_user_session_url)
    end

  end

  context 'user' do
    it 'can view posts' do
      sign_in user
      get :index

      expect(assigns(:posts)).to  match_array posts
      expect(response).to render_template :index
    end

    it 'can view post' do
      sign_in user
      get :show, params: { id: writer_post.id }

      expect(response).to render_template :show
    end

    it 'can`t start create post' do
      sign_in user
      get :new

      expect(response).to redirect_to(root_path)
    end

    it 'can`t create post' do
      sign_in user

      expect { create_post }.to_not change { Post.count }
      expect(response).to redirect_to(root_path)

    end

    it 'can`t start update post' do
      sign_in user
      get :edit, params: {id: writer_post.id}

      expect(response).to redirect_to(root_path)
      expect(assigns(:post).name).to_not eq 'Post updated!'
    end

    it 'can`t update post' do
      sign_in user
      update_post

      expect(response).to redirect_to(root_path)
    end

    it 'can`t delete post' do
      sign_in user
      posts
      expect { delete_post }.to_not change { Post.count }
      expect(response).to redirect_to(root_path)
    end

  end

  context 'writer' do
    it 'can start create post' do
      sign_in writer
      get :new

      expect(response).to render_template :new
    end

    it 'can create post' do
      sign_in writer

      expect { create_post }.to change { Post.count }
      expect(response).to have_http_status(:redirect)
    end

    it 'can start edit post' do
      sign_in writer
      get :edit, params: {id: writer_post.id}

      expect(response).to render_template(:edit)
    end

    it 'can update post' do
      sign_in writer
      update_post

      expect(response).to redirect_to post_path(id: writer_post.id)
      expect(assigns(:post).name).to eq 'Post updated!'
    end

    it 'can delete post' do
      sign_in writer

      expect { delete_post }.to change { Post.count }
      expect(response).to redirect_to posts_path
    end
  end
end
