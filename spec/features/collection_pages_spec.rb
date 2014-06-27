require 'rails_helper'

describe 'Contributor collection page' do
  before :each do
    @author = FactoryGirl.create :contributor
    post = FactoryGirl.create :soundcloud_post
    post.contributor = @author
    post.save
    title = FactoryGirl.create :tagged_text
    title.post = post
    title.save
    body = FactoryGirl.create :tagged_body
    body.post = post
    body.save

    sign_in
  end

  it 'has contributor\'s posts' do
    author_id = @author.id
    path = "/contributors/#{ author_id }"
    visit path
    expect(page).to have_content "#{ @author.name }'s posts"
    expect(page).to have_content 'Lorem ipsum dolor sit amet'
  end
end