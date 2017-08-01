require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  context 'when anonymouse user access to application' do
    let(:posts) { create_list(:post, 10) }

    it 'can view posts' do
      get :index

      expect(assigns(:posts)).to  match_array posts
    end

    xit 'can`t create post' do
      get :new

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'can view posts' do
      get :index

      expect(response).to render_template :index
    end
  end

end
