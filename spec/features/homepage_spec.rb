require 'rails_helper'

describe 'Home page' do
  it 'should not show New Post' do
    visit '/'
    expect(page).to_not have_content 'New post'
  end
end