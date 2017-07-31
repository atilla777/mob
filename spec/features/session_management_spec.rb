require 'rails_helper'

feature 'session management' do
  scenario 'anonymouse user try access to page' do
    visit '/'

    expect(page).to have_button('Sign in')
  end

  scenario 'user registration' do
    visit '/'
    click_link 'Sign up'
    fill_in 'Name', with: 'Aleksey'
    fill_in 'Email', with: 'aleksey@localhost'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_button('Sign in')
  end
end
