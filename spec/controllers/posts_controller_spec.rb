require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user)}
  let(:posts) { create_list(:post, 10) }
  let(:create_post) { post :create, params: { post: attributes_for(:post, user_id: user.id) } }

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
      #post :create, params: {post: attributes_for(:post) }

      expect { create_post }.to_not change { Post.count }
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

    it 'can start create post' do
      sign_in user
      get :new

      expect(response).to render_template :new
    end

    it 'can create post' do
      sign_in user

      expect { create_post }.to change { Post.count }
      expect(response).to have_http_status(:redirect)
    end
  end

end
