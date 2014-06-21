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

class Post < ActiveRecord::Base
  belongs_to :contributor
  has_many :tagged_texts
  has_many :tag_ranges, through: :tagged_texts
  has_many :tags, ->  { uniq }, through: :tagged_texts

  validates :contributor_id, presence: true, numericality: { greater_than: 0 }
  validates :player_type, presence: true, inclusion: { in: ['soundcloud', 'bopfm'] }

  def author
    return self.contributor
  end
end
