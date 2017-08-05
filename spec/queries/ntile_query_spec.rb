require 'rails_helper'

RSpec.describe 'ntile query' do
  let(:one_like_post) { create(:post, name: 'one_like_post') }
  let(:two_like_post) { create(:post, name: 'two_like_post') }
  let(:three_like_post) { create(:post, name: 'three_like_post') }
  let(:one_dislike_post) { create(:post, name: 'one_dislike_post') }
  let(:one_dislike_six_like_post) { create(:post, name: 'one_dislike_six_like_post') }

  it 'calculate posts rating' do
    create(:vote, :like, post_id: one_like_post.id)
    2.times do
      create(:vote, :like, post_id: two_like_post.id)
    end
    3.times do
      create(:vote, :like, post_id: three_like_post.id)
    end
    create(:vote, :dislike, post_id: one_dislike_post.id)
    create(:vote, :dislike, post_id: one_dislike_six_like_post.id)
    6.times do
      create(:vote, :like, post_id: one_dislike_six_like_post.id)
    end
    ratings = NtileQuery.call
    #expect(ratings.).to eq
  end
end
