require 'rails_helper'

feature 'posts management' do
  given(:writer) { create(:user, :writer) }
  given(:user) { create(:user) }
  before(:each) { create_list(:post, 5, user_id: writer.id) }
  given(:post) { Post.first }
  given(:posts) { Post.all}
  given(:writer_posts) { Post.where(user_id: writer.id) }
  given(:writer_post) { Post.where(user_id: writer.id).first }

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

    scenario 'he can`t delete post' do
      login_as(user, scope: :user)
      page.driver.submit :delete, "/posts/#{post.id}", {}

      expect(page).to have_content(posts.last.body)
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

    scenario 'he delete post', js: true do
      login_as(writer, scope: :user)
      body = writer_post.body
      visit "/posts/"
      find("a[href='/posts/#{writer_post.id}']").click
      click_on I18n.t('views.action.delete')
      page.accept_confirm

      expect(page).to_not have_content(body)
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
