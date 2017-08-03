require 'rails_helper'

feature 'comment management' do
  given(:user) { create(:user) }
  given(:post) { create(:post) }

  feature 'by user' do
    scenario 'he can make comment', js: true do
      login_as user
      visit "/posts/#{post.id}"
      within '#add_comment' do
        fill_in Comment.human_attribute_name(:comment), with: 'Edited!'
      end
      click_button I18n.t('helpers.submit.save')

      expect(page).to have_text('Edited!')
    end
  end

  feature 'by anonumouse', js: true do
    scenario 'he can`t start leave a comment' do
      visit "/posts/#{post.id}"

      expect(page).to_not have_css('div#add_comment')
    end
  end
end
