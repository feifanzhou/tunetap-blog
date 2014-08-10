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
#  original_code      :string(255)
#

class Post < ActiveRecord::Base
  belongs_to :contributor
  has_many :tagged_texts
  has_many :tag_ranges, through: :tagged_texts
  # has_many :tags, ->  { uniq }, through: :tag_ranges
  has_many :post_tags
  has_many :tags, through: :post_tags

  has_attached_file :image

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :contributor_id, presence: true, numericality: { greater_than: 0 }
  validates :player_type, presence: true, inclusion: { in: ['soundcloud', 'bopfm', 'spotify', 'youtube', 'vimeo', 'unknown'] }
  # FIXME — Make sure post has title

  def self.embed_color
    return 'F6921E'
  end
  def embed_color
    return 'F6921E'
  end

  def path_with_slug
    if self.title.blank?
      return "/posts/#{ self.id }"
    else
      return "/posts/#{ self.id }/#{ self.title_text.parameterize }"
    end
  end

  include PostsHelper
  def process_player_embed(embed_link)
    if embed_link.include? 'bop.fm'
      process_bop_embed(self, embed_link)
    elsif embed_link.include? 'soundcloud.com'
      process_soundcloud_embed(self, embed_link)
    elsif embed_link.include? 'spotify'
      process_spotify_embed(self, embed_link)
    elsif embed_link.include? 'youtube'
      process_youtube_embed(self, embed_link)
    elsif embed_link.include? 'vimeo'
      process_vimeo_embed(self, embed_link)
    else
      process_unknown_embed(self, embed_link)
    end
    self.original_code = embed_link
  end

  def embed_code
    if self.player_type == 'bopfm'
      return self.player_embed.html_safe
    elsif self.player_type == 'soundcloud'
      height = self.download_link.blank? ? 220 : 180
      return "<iframe width='100%' height='#{ height }' scrolling='no' frameborder='no' src='#{ self.player_embed }'></iframe>".html_safe
    elsif self.player_type == 'spotify'
      return "<iframe src='https://embed.spotify.com/?uri=#{ self.player_embed }&theme=white' width='280' height='360' frameborder='0' allowtransparency='true'></iframe>".html_safe
    elsif self.player_type == 'youtube'
      return "<iframe width='100%' height='100%' src='//www.youtube.com/embed/#{ self.player_embed }?rel=0' frameborder='0' allowfullscreen></iframe>".html_safe
    elsif self.player_type == 'vimeo'
      return "<iframe src='//player.vimeo.com/video/#{ self.player_embed }?title=0&amp;byline=0&amp;portrait=0&amp;badge=0&amp;color=#{ Post.embed_color }' width='100%' height='100%' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>".html_safe
    end
  end

  def save_content(tagged_texts, tag_ranges, contributor)
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
    unless title.blank?
      current_title = TaggedText.find_by_post_id_and_content_type(self.id, 'title')
      current_title.destroy if current_title
      title.post = self
      title.save
    end
    unless body.blank?
      current_body = TaggedText.find_by_post_id_and_content_type(self.id, 'body')
      current_body.destroy if current_body
      body.post = self
      body.save
    end

    return if tag_ranges.blank?
    tag_ranges.each do |tr|
      range = tr[1]
      tag_range = TagRange.new(range.except(:content_type, :text))
      if range[:tag_id].blank? && !range[:text].blank?
        # Need to create new tag
        # FIXME — Add tests for this
        t = Tag.new(name: range[:text], description: '', tag_type: 'other')
        t.contributor = contributor
        t.save
        tag_range.tag = t
      end
      if range[:content_type] == 'title'
        tag_range.tagged_text = title
      elsif range[:content_type] == 'body'
        tag_range.tagged_text = body
      end
      tag_range.save
    end
  end

  def save_tags(tags_text, contributor)
    return if tags_text.blank?
    tags_array = tags_text.split
    tags_array = tags_array.map { |t| t.chomp ',' if t }
    tags_array.each do |t|
      tag = Tag.create_or_find_by_name(t, contributor)
      PostTag.create(post_id: self.id, tag_id: tag.id) unless PostTag.find_by_post_id_and_tag_id(self.id, tag.id)
    end
  end

  def self.posts_for_page(page = 1, posts_per_page = 10, show_deleted = false)
    p = show_deleted ? Post.all : Post.where('is_deleted = false')
    p.order(created_at: :desc).limit(posts_per_page).offset((page - 1) * posts_per_page).to_a
  end

  def blank?
    tagged_texts.size == 0 || super
  end

  # ========== Post content ==========
  def author
    return self.contributor
  end

  def title
    self.tagged_texts.where('content_type = ?', 'title').first
  end
  def title_text
    self.title ? self.title.content : ''
  end

  def body
    self.tagged_texts.where('content_type = ?', 'body').first
  end
  def body_text
    self.body ? self.body.content : ''
  end

  def facebook_buttons
    fb_buttons_for_post(self)
  end
  def twitter_button
    twitter_button_for_post(self)
  end

  def tags_text
    self.tags.inject('') { |mem, next_tag| mem + " #{ next_tag.name }" }
  end

  def vote_for_session(session)
    Vote.find_by_post_id_and_session_id(self.id, session.id)
  end
  include SessionsHelper
  def current_vote
    vote_for_session(active_session)
  end
  def upvote_count
    Vote.where('post_id=(?) AND is_deleted=false AND is_upvote=true', self.id).count
  end
  def downvote_count
    Vote.where('post_id=(?) AND is_deleted=false AND is_upvote=false', self.id).count
  end
end
