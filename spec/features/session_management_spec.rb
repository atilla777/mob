require 'rails_helper'

feature 'session management' do
  given(:user) { create(:user, name: 'Mike',
                        email: 'mike@home.io',
                        password: '123456') }
  given(:not_confirmed_user) { create(:user,
                                      name: 'John',
                                      email: 'john@home.io',
                                      password: '654321',
                                      confirmed: false) }

  scenario 'anonymouse user try access to page' do
    visit '/'

    expect(page).to have_link('Sign in')
    expect(page).to have_content(Post.model_name.human count: 2)
  end

  scenario 'new user make registration' do
    visit '/'
    click_link I18n.t('helpers.link_to.login')
    click_link I18n.t('helpers.link_to.signup')
    fill_in 'Name', with: 'Aleksey'
    fill_in 'Email', with: 'aleksey@localhost'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button I18n.t('helpers.link_to.login')

    expect(page).to have_text I18n.t('devise.registrations.user.signed_up_but_unconfirmed')
    expect(page).to have_link I18n.t('helpers.link_to.login')
  end

  scenario 'new but not confirmed user try enter to application' do
    visit '/users/sign_in'
    fill_in 'Email', with: not_confirmed_user.email
    fill_in 'Password', with: '654321'
    click_button 'Sign in'

    expect(page).to_not have_text not_confirmed_user.name
    expect(page).to have_button 'Sign in'
  end

  scenario 'registered user enter to application' do
    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123456'
    click_button 'Sign in'

    expect(page).to have_text 'Mike'
    expect(page).to have_link 'Logout'
  end

  scenario 'registered user enter to application with bad password' do
    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '654321'
    click_button 'Sign in'

    expect(page).to_not have_text 'Mike'
    expect(page).to have_button 'Sign in'
  end

  scenario 'unregistered user enter to application' do
    visit '/users/sign_in'
    fill_in 'Email', with: 'fake@mail.com'
    fill_in 'Password', with: '123456'
    click_button 'Sign in'

    expect(page).to have_text I18n.t('devise.failure.not_found_in_database')
    expect(page).to have_button 'Sign in'
  end
end
