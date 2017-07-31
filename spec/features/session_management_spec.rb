require 'rails_helper'

feature 'users session management' do
  scenario 'anonymouse user try access to page' do
    visit '/'

    expect(page).to have_text('Sign up')
  end
end
