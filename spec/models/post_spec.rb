# == Schema Information
#
# Table name: posts
#
#  id                 :integer          not null, primary key
#  contributor_id     :integer
#  image_url          :string(255)
#  player_embed       :string(255)
#  player_type        :string(255)
#  download_link      :string(255)
#  twitter_text       :string(255)
#  facebook_text      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  is_deleted         :boolean
#

require 'rails_helper'

RSpec.describe Post, :type => :model do
  let(:post) { FactoryGirl.create :post }

  subject { post }
  it { should be_valid }
  it { should respond_to :contributor_id }
  it { should respond_to :player_type }

  it 'is blank without tagged texts' do
    expect(post.blank?).to be true
  end

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

  it 'generates the right Facebook buttons' do
    title = FactoryGirl.build :tagged_title
    title.post = post
    title.save
    # Now post has a title
    expected = "<div class='fb-like' data-href='http://localhost:3000/posts/#{ post.id }/lorem-ipsum' data-layout='button_count' data-action='like' data-show-faces='false' data-share='true'></div>"
    expect(post.facebook_buttons).to eq(expected)
  end

  it 'generates the right Twitter button' do
    title = FactoryGirl.build :tagged_title
    title.post = post
    title.save
    # Now post has a title
    expected = "<a href='https://twitter.com/share' class='twitter-share-button' data-text='To be tweeted' data-url='http://localhost:3000/posts/#{ post.id }' data-via='CamelbackMusic'>Tweet</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>"
    expect(post.twitter_button).to eq(expected)
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

describe 'Post embed code' do
  it 'gets the right embed code for bop.fm' do
    post = FactoryGirl.create :bop_post
    expect(post.embed_code).to eq('<a data-width="358" data-bop-link href="http://bop.fm/s/lana-del-rey/west-coast">Lana Del Rey - West Coast | Listen for free at bop.fm</a><script async src="http://assets.bop.fm/embed.js"></script>')
  end
  it 'gets the right embed code for Soundcloud' do
    post = FactoryGirl.create :soundcloud_post
    expect(post.embed_code).to eq("<iframe width='100%' height='180' scrolling='no' frameborder='no' src='https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/151835201&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true'></iframe>")
  end
  it 'saves correctly given a Bop.fm' do
    post = FactoryGirl.create :post
    post.process_player_embed('<a data-width="358" data-bop-link href="http://bop.fm/s/lana-del-rey/west-coast">Lana Del Rey - West Coast | Listen for free at bop.fm</a><script async src="http://assets.bop.fm/embed.js"></script>')
    expect(post.player_type).to eq('bopfm')
    expect(post.player_embed).to eq('<a data-width="358" data-bop-link href="http://bop.fm/s/lana-del-rey/west-coast">Lana Del Rey - West Coast | Listen for free at bop.fm</a><script async src="http://assets.bop.fm/embed.js"></script>')
  end
  it 'saves correctly given a Soundcloud link' do
    post = FactoryGirl.create :post
    post.process_player_embed('<iframe width="100%" height="300" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/151835201&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true"></iframe>')
    expect(post.player_type).to eq('soundcloud')
    expect(post.player_embed).to eq('https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/151835201&amp;color=F6921E&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;')
  end
end
