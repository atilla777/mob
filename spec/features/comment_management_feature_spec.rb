require 'rails_helper'

feature 'comment management' do
  given(:user) { create(:user) }
  given(:user_post) { create(:post, user_id: user.id) }
  given(:user_comment) { create(:comment,
                                user_id: user.id,
                                post_id: user_post.id) }

  feature 'by user' do
    scenario 'he can make comment', js: true do
      login_as user
      visit "/posts/#{user_post.id}"
      within '#new_comment' do
        fill_in Comment.human_attribute_name(:body), with: 'Created by user!'
      end
      click_button I18n.t('helpers.submit.save')

      expect(page).to have_text('Created by user!')
    end

    scenario 'he can edit comment', js: true do
      login_as user
      user_comment
      visit "/posts/#{user_post.id}"
      find("a[data-comment-id=\"#{user_comment.id}\"]").click
      within "#edit_comment_#{user_comment.id}" do
        fill_in Comment.human_attribute_name(:body), with: 'Edited by user!'
        click_button I18n.t('helpers.submit.save')
      end

      expect(page).to have_content('Edited by user!')
    end

    scenario 'he can delete comment', js: true do
      login_as user
      user_comment
      visit "/posts/#{user_post.id}"
      find("a[href=\"#{post_comment_path(post_id: user_post.id, id: user_comment.id)}\"]").click
      page.accept_confirm

      expect(page).to_not have_link(:css, "a[data-comment-id=\"#{user_comment.id}\"]")
    end
  end

  feature 'by anonumouse', js: true do
    scenario 'he can`t start leave a comment' do
      visit "/posts/#{user_post.id}"

      expect(page).to_not have_css('div#add_comment')
    end

    scenario 'he can`t start edit comment', js: true do
      user_comment
      visit "/posts/#{user_post.id}"

      expect(page).to_not have_css("a[data-comment-id=\"#{user_comment.id}\"]")
    end

    scenario 'he can`t delete comment', js: true do
      user_comment
      visit "/posts/#{user_post.id}"

      expect(page).to_not have_link(:css, "a[href=\"#{post_comment_path(post_id: user_post.id, id: user_comment.id)}\"]")
    end
  end
end
