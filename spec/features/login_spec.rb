require 'rails_helper'

describe 'Login page' do
  it 'has the right fields' do
    visit '/contributors/login'
    expect(page).to have_selector '#new_contributor'
    expect(page).to_not have_content 'Name'
  end

  it 'shows an error if login is incorrect' do
    FactoryGirl.create :contributor
    visit '/contributors/login'
    within '#new_contributor' do
      fill_in 'contributor_email', with: 'mike@tunetap.com'
      fill_in 'contributor_password', with: 'wrongpassword'
    end
    click_button 'Login'
    expect(page).to have_content 'error'
  end

  it 'goes to home page and shows New post if login is correct' do
    FactoryGirl.create :contributor
    visit '/contributors/login'
    within '#new_contributor' do
      fill_in 'contributor_email', with: 'mike@tunetap.com'
      fill_in 'contributor_password', with: 'loginpass'
    end
    click_button 'Login'
    expect(page).to have_content 'New post'
  end
end