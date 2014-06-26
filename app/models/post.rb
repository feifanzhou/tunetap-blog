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
  # FIXME — Make sure post has title

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
    self.player_type = 'bopfm'
  end

  def save_content(tagged_texts, tag_ranges)
    title = nil
    body = nil
    tagged_texts.each do |tt|
      tagged_text = tt[1]
      if tagged_text[:content_type] == 'title'
        title = TaggedText.new(tagged_text)
      elsif tagged_text[:content_type] == 'body'
        body = TaggedText.new(tagged_text)
      end
    end
    title.post = self and title.save if !title.blank?
    body.post = self and body.save if !body.blank?

    return if tag_ranges.blank?
    tag_ranges.each do |tr|
      range = tr[1]
      pp range
      tag_range = TagRange.new(range.except(:content_type))
      if range[:content_type] == 'title'
        tag_range.tagged_text = title
      elsif range[:content_type] == 'body'
        tag_range.tagged_text = body
      end
      tag_range.save
    end
  end

  def self.posts_for_page(page = 1, posts_per_page = 10)
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

  include PostsHelper
  def facebook_buttons
    fb_buttons_for_post(self)
  end
  def twitter_button
    twitter_button_for_post(self)
  end
end
