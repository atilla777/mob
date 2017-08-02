require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user)}
  let(:writer) { create(:user, writer: true)}
  let(:posts) { create_list(:post, 10) }
  let(:writer_posts) { create_list(:post, 10, user_id: writer.id) }
  let(:create_post) { post :create, params: { post: attributes_for(:post, user_id: user.id) } }
  let(:update_post) { put :update, params: { id: writer_posts.first.id, post: { name: 'Post updated!'}} }

  context 'anonymouse user' do
    it 'can view posts' do
      get :index

      expect(assigns(:posts)).to  match_array posts
    end

    it 'can`t start create post' do
      get :new

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'can`t create post' do
      expect { create_post }.to_not change { Post.count }
      expect(response).to redirect_to(new_user_session_url)

    end
    it 'can`t start create post' do
      get :new

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'can`t start update post' do
      post = posts.first
      get :edit, params: {id: post.id}

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'can view posts' do
      get :index

      expect(response).to render_template :index
    end

    it 'can view post' do
      get :show, params: { id: posts.first.id }

      expect(response).to render_template :show
    end
  end

  context 'user' do
    it 'can view posts' do
      sign_in user
      get :index

      expect(response).to render_template :index
    end

    it 'can view post' do
      sign_in user
      post = posts.first
      get :show, params: { id: post.id }

      expect(response).to render_template :show
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
      post = writer_posts.first
      get :edit, params: {id: post.id}

      expect(response).to render_template(:edit)
    end

    it 'can update post' do
      sign_in writer
      update_post

      expect(response).to redirect_to post_path(id: writer_posts.first.id)
    end
  end
end
