require 'rails_helper'

feature 'vote management' do
  given(:user) { create(:user) }
  given(:user_post) { create(:post, user_id: user.id) }
  given(:other_user) { create(:user) }
  given(:other_user_like) do
    create(:vote, :like, user_id: other_user.id, post_id: user_post.id)
  end

  feature 'by user' do
    scenario 'he can`t like post', js: true do
      login_as user
      visit "/posts/#{user_post.id}"
      find("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=1\"").click

      within("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=1\"") do
        expect(page).to have_content('0')
      end
    end
    scenario 'he can`t dislike post', js: true do
      login_as user
      visit "/posts/#{user_post.id}"
      find("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=-1\"").click

      within("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=-1\"") do
        expect(page).to have_content('0')
      end
    end
  end

  feature 'by other user' do
    scenario 'he like post', js: true do
      login_as other_user
      visit "/posts/#{user_post.id}"
      find("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=1\"").click

      within("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=1\"") do
        expect(page).to have_content('1')
      end
    end

    scenario 'he dislike post', js: true do
      login_as other_user
      visit "/posts/#{user_post.id}"
      find("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=-1\"").click

      within("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=-1\"") do
        expect(page).to have_content('1')
      end
    end

    scenario 'he dislike previously liked post', js: true do
      login_as other_user
      other_user_like
      visit "/posts/#{user_post.id}"
      find("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=-1\"").click

      within("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=-1\"") do
        expect(page).to have_content('1')
      end
      within("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=1\"") do
        expect(page).to have_content('0')
      end
    end
  end

  feature 'by unonymouse' do
    scenario 'he can`t like post', js: true do
      visit "/posts/#{user_post.id}"
      find("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=1\"").click

      within("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=1\"") do
        expect(page).to have_content('0')
      end
    end
    scenario 'he can`t dislike post', js: true do
      visit "/posts/#{user_post.id}"
      find("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=-1\"").click

      within("a[href=\"/posts/#{user_post.id}/votes?vote%5Bscore%5D=-1\"") do
        expect(page).to have_content('0')
      end
    end
  end
end
