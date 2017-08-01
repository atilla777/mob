require 'rails_helper'

feature 'posts management' do
  given(:user) { create(:user) }
  given(:posts) { create_list(:post, 10) }

  scenario 'user can view posts' do
    login_as(user, scope: :user)
    visit '/posts'

    expect(page).to have_content posts.first.body
    expect(page).to have_content posts.last.body
  end
end
