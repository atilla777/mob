require 'rails_helper'

feature 'posts management' do
  given(:user) { create(:user) }
  given(:writer) { create(:user, writer: true) }
  given(:posts) { create_list(:post, 10) }

  scenario 'user can view posts' do
    login_as(user, scope: :user)
    visit '/posts'

    expect(page).to have_content posts.first.body
    expect(page).to have_content posts.last.body
  end

  scenario 'anonymouse can view posts' do
    visit '/posts'

    expect(page).to have_content posts.first.body
    expect(page).to have_content posts.last.body
  end

  scenario 'user can view post' do
    login_as(user, scope: :user)
    post = Post.where(name: "#{posts.first.name}").first
    visit "/posts/#{post.id}"

    expect(page).to have_content(post.body)
  end

  scenario 'anonymouse can view post' do
    post = Post.where(name: "#{posts.first.name}").first
    visit "/posts/#{post.id}"

    expect(page).to have_content(post.body)
  end

  scenario 'writer can create post' do
    login_as(writer, scope: user)
    visit '/posts'
    click_on "#{I18n.t('helpers.submit.create', model: Post.model_name.human)}"
    fill_in 'Name', with: 'Post'
    fill_in 'Body', with: 'Users post!'
    click_button I18n.t('helpers.submit.save')

    expect(page).to have_content 'Users post!'
  end
end
