require 'rails_helper'

require 'rake'
describe 'Search' do
  before :all do
    # http://stackoverflow.com/a/19930700/472768
    Rails.application.load_seed
  end

  before :each do
    visit '/'
  end

  describe 'on homepage' do
    it 'should not show results on load' do
      expect(page).to_not have_content('No results found')
    end

    it 'should show "No results found" when search comes up blank' do
      fill_in 'searchField', with: 'asontehuntoehtnuh'
      expect(page).to have_content 'No results found'
    end
  end
end