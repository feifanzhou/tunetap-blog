# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  contributor_id :integer
#  image_url      :string(255)
#  player_embed   :string(255)
#  player_type    :string(255)
#  download_link  :string(255)
#  twitter_text   :string(255)
#  facebook_text  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'rails_helper'

RSpec.describe Post, :type => :model do
  let(:post) { FactoryGirl.create :post }

  subject { post }
  it { should be_valid }
  it { should respond_to :contributor_id }
  it { should respond_to :player_type }

  it 'gets the right body' do
    body = FactoryGirl.build :tagged_body
    body.post = post
    body.save
    expect(post.body.id).to eq(body.id)
  end

  it 'generates the right slugged path' do
    # Post currently doesn't have a title
    expect(post.path_with_slug).to eq("/posts/#{ post.id }")
    title = FactoryGirl.build :tagged_title
    title.post = post
    title.save
    # Now post has a title
    expect(post.path_with_slug).to eq("/posts/#{ post.id }/lorem-ipsum")
  end
end

describe 'Post title' do
  before :all do
    @post = FactoryGirl.create :post
    @title = FactoryGirl.build :tagged_title
    @title.post = @post
    @title.save
  end

  it 'gets the right instance' do
    expect(@post.title.id).to eq(@title.id)
  end
  it 'gets the right text' do
    expect(@post.title_text).to eq('Lorem ipsum')
  end
end