require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:user_post) { create(:post, user_id: user.id) }
  let(:other_user) { create(:user) }
  let(:third_user) { create(:user) }
  let(:third_user_like) { create(:vote, :like,
                                 post_id: user_post.id,
                                 user_id: third_user.id)}
  let(:third_user_dislike) { create(:vote, :dislike,
                                 post_id: user_post.id,
                                 user_id: third_user.id)}
  let(:create_like) do
    post :create, params: { vote: { score: 1 },
                            post_id: user_post.id,
                            user_id: other_user.id }, format: :js
  end
  let(:create_dislike) do
    post :create, params: { vote: { score: -1 },
                            post_id: user_post.id,
                            user_id: other_user.id }, format: :js
  end
  let(:other_vote)  do
    Vote.where(post_id: user_post.id, user_id: other_user.id).first
  end

  context 'other user' do
    it 'can like post' do
      user_post
      sign_in other_user

      expect { create_like }.to change { Vote.count }
      expect(response).to have_http_status(200)
    end

    it 'can dislike post' do
      user_post
      sign_in other_user

      expect { create_dislike }.to change { Vote.count }
      expect(response).to have_http_status(200)
    end

    it 'can`t twice like post' do
      user_post
      sign_in other_user
      create_like

      expect { create_like }.to_not change { Vote.count }
      expect(response).to have_http_status(200)
    end

    it 'can`t twice dislike post' do
      user_post
      sign_in other_user
      create_dislike

      expect { create_dislike }.to_not change { Vote.count }
      expect(response).to have_http_status(200)
    end

    it 'can like post already liked' do
      user_post
      third_user_like
      sign_in other_user

      expect { create_like }.to change { Vote.count }
      expect(user_post.votes.count).to eq 2
      expect(response).to have_http_status(200)
    end

    it 'can dislike post already disliked' do
      user_post
      third_user_dislike
      sign_in other_user

      expect { create_dislike }.to change { Vote.count }
      expect(user_post.votes.count).to eq 2
      expect(response).to have_http_status(200)
    end
  end

  context 'user' do
    it 'can`t like himself' do
      sign_in user
      user_post

      expect { create_like }.to_not change { Vote.count }
      expect(response).to have_http_status(403)
    end
    it 'can`t dislike himself' do
      sign_in user
      user_post

      expect { create_dislike }.to_not change { Vote.count }
      expect(response).to have_http_status(403)
    end
  end

  context 'anonymouse' do
    it 'can`t like' do
      user_post

      expect { create_like }.to_not change { Vote.count }
      expect(response).to have_http_status(401)
    end
    it 'can`t dislike' do
      user_post

      expect { create_dislike }.to_not change { Vote.count }
      expect(response).to have_http_status(401)
    end
  end
end
