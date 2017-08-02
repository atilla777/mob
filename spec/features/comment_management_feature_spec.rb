require 'rails-helper'

feature 'comment management' do
  given(:user) { create(:user) }
  given(:posts) { create(:post) }

  feature 'by user' do
    scenario 'user can make comment' do
      login_as user
      visit "/posts/#{post.id}"
      within '.comments' do
        fill_in Comment.human_attribute_name :body, with: 'Edited!'
      end
      click_button I18n.t('views.action.save')

      expect(page).to have_text('Edited!')

    end
  end
end
