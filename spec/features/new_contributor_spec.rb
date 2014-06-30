require 'rails_helper'

describe 'New contributor signup' do
  it 'renders contributors#new if no contributors in database' do
    visit '/contributors/new'
    expect(page).to have_selector '#new_contributor'
  end

  describe 'with existing contributor' do
    before :each do FactoryGirl.create :contributor end
    it 'renders :forbidden if there is no access code' do
      visit '/contributors/new'
      expect(page.status_code).to eq(403)
    end

    describe 'and existing invitation' do
      before :each do FactoryGirl.create :invitation end

      it 'renders :forbidden if invalid access code is provided' do
        visit '/contributors/new?access_code=thisisntright'
        expect(page.status_code).to eq(403)
      end
      # it 'renders :forbidden if access code has expired'
      it 'renders contributors#new if correct access code is provided' do
        visit '/contributors/new?access_code=letmein'
        expect(page).to have_selector '#new_contributor'
      end
    end
  end

  def go_signup(access_code = '')
    path = '/contributors/new'
    path << "?access_code=#{ access_code }" if !access_code.blank?
    visit path
    within '#new_contributor' do
      fill_in 'contributor_name', with: 'feifan'
      fill_in 'contributor_email', with: 'feifan@me.com'
      fill_in 'contributor_password', with: 'letmein'
    end
    click_button 'Get started'
  end

  describe 'create process without invitation' do
    it 'saves an admin contributor if this is the first one' do
      contributor_count = Contributor.count
      go_signup
      expect(Contributor.count).to eq(contributor_count + 1)
      expect(Contributor.last.is_admin).to be true
    end
  end

  describe 'create process with existing contributors and non-admin invitation' do
    before :each do 
      FactoryGirl.create :contributor
      FactoryGirl.create :invitation
    end

    it 'saves a non-admin contributor' do
      contributor_count = Contributor.count
      go_signup('letmein')
      expect(Contributor.count).to eq(contributor_count + 1)
      expect(Contributor.last.is_admin).to be false
    end
  end

  it 'remembers login after creating account' do
    go_signup('letmein')
    visit "/contributors/#{ Contributor.last.id }"
    expect(page.status_code).to eq(200)
  end

  it 'goes to home page with New Post fields' do
    go_signup('letmein')
    expect(page).to have_content 'New Post'
  end
end