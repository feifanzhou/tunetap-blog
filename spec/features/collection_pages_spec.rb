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
  end

  it 'has contributor\'s posts' do
    author_id = @author.id
    path = "/contributors/#{ author_id }"
    visit path
    expect(page).to have_content "#{ @author.name }'s posts"
    expect(page).to have_content 'Lorem ipsum dolor sit amet'
  end
end

describe 'Tag collection page' do
  before :each do
    @author = FactoryGirl.create :contributor
    post = FactoryGirl.create :soundcloud_post
    post.contributor = @author
    post.save
    @lana_tag = Tag.new(name: 'Lana Del Rey', tag_type: 'artist')
    @lana_tag.contributor = @author
    @lana_tag.save
    title = TaggedText.new(content_type: 'title', content: 'Check out Lana Del Rey’s new single West Coast')
    title.post = post
    title.save
    body = TaggedText.new(content_type: 'body', content: 'Helvetica seitan Austin slow-carb, quinoa iPhone tousled jean shorts 3 wolf moon before they sold out next level literally photo booth Williamsburg. Kickstarter fashion axe chillwave, Helvetica try-hard wayfarers scenester 8-bit squid mlkshk ennui. Ugh +1 farm-to-table kitsch, small batch Bushwick keffiyeh cray viral. High Life quinoa Etsy, Thundercats Marfa Pitchfork Tumblr jean shorts mustache stumptown viral lomo small batch keytar. Tattooed viral brunch, squid Williamsburg Thundercats swag umami. Cornhole Banksy forage, disrupt 90s art party artisan aesthetic craft beer bicycle rights umami seitan pickled organic. Beard banjo actually roof party cray YOLO street art literally.')
    body.post = post
    body.save
    tag_range = TagRange.new(start: 10, length: 12)
    tag_range.tagged_text = title
    tag_range.tag = @lana_tag
    tag_range.save
  end

  it 'has tag\'s posts' do
    tag_id = @lana_tag.id
    path = "/tags/#{ tag_id }"
    visit path
    expect(page).to have_content "Posts tagged with #{ @lana_tag.name }"
    expect(page).to have_content 'Helvetica seitan Austin slow-carb'
  end
end