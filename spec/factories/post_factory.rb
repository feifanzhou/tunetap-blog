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
#

FactoryGirl.define do
  factory :post do
    contributor_id 1
    image_url 'https://scontent-b-iad.xx.fbcdn.net/hphotos-ash3/t1.0-9/1969121_677884932255138_1459446033_n.jpg'
    player_embed 'soundcloud.com'
    player_type 'unknown'
    twitter_text 'To be tweeted'
  end

  factory :soundcloud_post, class: Post do
    contributor_id 1
    player_embed 'https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/151835201&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true'
    player_type 'soundcloud'
  end

  factory :bop_post, class: Post do
    contributor_id 1
    player_embed '<a data-width="358" data-bop-link href="http://bop.fm/s/lana-del-rey/west-coast">Lana Del Rey - West Coast | Listen for free at bop.fm</a><script async src="http://assets.bop.fm/embed.js"></script>'
    player_type 'bopfm'
  end
end

