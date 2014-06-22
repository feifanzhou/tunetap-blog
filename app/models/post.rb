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
  has_many :tags, ->  { uniq }, through: :tag_ranges

  validates :contributor_id, presence: true, numericality: { greater_than: 0 }
  validates :player_type, presence: true, inclusion: { in: ['soundcloud', 'bopfm'] }

  def embed_color
    return 'F16214'
  end

  def path_with_slug
    if self.title.blank?
      return "/posts/#{ self.id }"
    else
      return "/posts/#{ self.id }/#{ self.title_text.parameterize }"
    end
  end

  # FIXME — Fill in
  def process_player_embed(embed_link)
  end

  def self.posts_for_page(page = 1, posts_for_page = 10)
    Post.order(created_at: :desc).limit(posts_per_page).offset(page - 1).to_a
  end

  # ========== Post content ==========
  def author
    return self.contributor
  end

  def title
    self.tagged_texts.where('content_type = ?', 'title').first
  end
  def title_text
    self.title.content
  end

  def body
    self.tagged_texts.where('content_type = ?', 'body').first
  end
end
