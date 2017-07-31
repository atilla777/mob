require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  context 'when anonymouse user try access to application' do
    let(:user) {nil}

    it 'then he redirect to login page' do
      get :index

      expect(response).to redirect_to(sign_in)
    end
  end

end
