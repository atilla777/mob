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
    rating = NtileQuery.call # [[post_id, score_sum, star], ...]
    expect(rating).to include [one_dislike_post.id, -1, 1]
    expect(rating).to include [one_like_post.id, 1, 2]
    expect(rating).to include [two_like_post.id, 2, 3]
    expect(rating).to include [three_like_post.id, 3, 4]
    expect(rating).to include [one_dislike_six_like_post.id, 5, 5]
  end
end
