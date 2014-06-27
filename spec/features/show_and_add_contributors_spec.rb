require 'rails_helper'

describe 'Contributors index page' do
  before :each do
    c = FactoryGirl.create :contributor
    visit '/contributors/login'
    within '#new_contributor' do
      fill_in 'contributor_email', with: 'mike@tunetap.com'
      fill_in 'contributor_password', with: 'loginpass'
    end
    click_button 'Login'
    # Create posts here to avoid display issues on homepage
    p = FactoryGirl.build :post
    p.contributor = c
    p.save
    p = FactoryGirl.build :soundcloud_post
    p.contributor = c
    p.save
    p = FactoryGirl.build :bop_post
    p.contributor = c
    p.save

    visit '/contributors'
  end

  it 'shows contributors\' details' do
    expect(page).to have_content 'Mike Falb'
    expect(page).to have_content 'mike@tunetap.com'
  end
  it 'shows contributors\' post count' do
    expect(page).to have_content '3'
  end

  it 'has "Invite new contributor" link' do
    expect(page).to have_link 'Invite new contributor'
  end
  it 'outputs invite link after clicking on "Invite new contributor"', js: true do
    click_link 'Invite new contributor'
    output = "#{ ENV['ROOT_URL'] }/contributors/new?access_code="
    expect(page).to have_content output
  end
end