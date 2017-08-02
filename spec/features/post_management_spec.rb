require 'rails_helper'

feature 'posts management' do
  before(:context) { create_list(:post, 10) }
  given(:post) { Post.first }
  given(:posts) { Post.all}
  given(:user) { create(:user) }
  given(:writer) { create(:user, :writer) }

  feature 'by user' do
    scenario 'he view posts' do
      login_as(user, scope: :user)
      visit '/posts'

      expect(page).to have_content posts.first.body
      expect(page).to have_content posts.last.body
    end

    scenario 'he view post' do
      login_as(user, scope: :user)
      visit "/posts/#{post.id}"

      expect(page).to have_content(post.body)
      expect(page).to_not have_content(posts.last.body)
    end

    scenario 'he can`t edit post' do
      login_as(user, scope: :user)
      visit '/posts/'

      expect(page).to_not have_selector(:link_or_button, I18n.t('views.action.edit'))

      visit "/posts/#{post.id}/edit"

      expect(page).to_not have_selector(:link_or_button, I18n.t('helpers.submit.save'))
    end
  end

  feature 'by writer' do
    scenario 'he create post' do
      login_as(writer, scope: :user)
      visit '/'
      click_on I18n.t('helpers.submit.create', model: Post.model_name.human)
      fill_in Post.human_attribute_name(:name), with: 'Post'
      fill_in Post.human_attribute_name(:body), with: 'Users post!'
      click_button I18n.t('helpers.submit.save')

      expect(page).to have_content 'Users post!'
    end

    scenario 'he edit post' do
      login_as(writer, scope: :user)
      visit "/posts/"
      find("a[href='/posts/#{post.id}/edit']").click
      fill_in Post.human_attribute_name(:name), with: 'I edited post!'
      click_button I18n.t('helpers.submit.save')

      expect(page).to have_content('I edited post!')
    end
  end

  feature 'by anonymouse' do
    scenario 'he view posts' do
      visit '/posts'

      expect(page).to have_content posts.first.body
      expect(page).to have_content posts.last.body
    end

    scenario 'he view post' do
      visit "/posts/#{post.id}"

      expect(page).to have_content(post.body)
      expect(page).to_not have_content(posts.last.body)
    end
  end
end
