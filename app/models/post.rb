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
  validates :player_type, presence: true, inclusion: { in: ['soundcloud', 'bopfm', 'unknown'] }
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

  def process_player_embed(embed_link)
    if embed_link.include? 'bop.fm'
      self.player_embed = embed_link
      self.player_type = 'bopfm'
    elsif embed_link.include? 'soundcloud.com'
      # FIXME — Clean up ugly code
      # Make sure to use short player
      # And set the correct color
      src_index = embed_link.index 'src='
      unless src_index.blank?
        src_index += 5
        end_index = embed_link.index('>') - 2
        new_link = embed_link[src_index..end_index]
      end

      color_index = new_link.index('color=')
      if color_index.blank?
        amp_index = new_link.index('&amp;')
        color_str = "&amp;color=#{ self.embed_color }"
        new_link.insert(amp_index, color_str)
      else
        color_index += 6
        color_end_index = color_index + 6
        new_link[color_index...color_end_index] = self.embed_color
      end

      # FIXME — Visual removal not working yet
      visual_index = new_link.index('visual=true')
      new_link = new_link[0...visual_index] if !visual_index.blank?

      self.player_embed = new_link
      self.player_type = 'soundcloud'
    else
      self.player_type = 'unknown'
    end
  end

  def embed_code
    if self.player_type == 'bopfm'
      return self.player_embed.html_safe
    elsif self.player_type == 'soundcloud'
      return "<iframe width='100%' height='202' scrolling='no' frameborder='no' src='#{ self.player_embed }'></iframe>".html_safe
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
    title.post = self and title.save if !title.blank?
    body.post = self and body.save if !body.blank?

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

  def self.posts_for_page(page = 1, posts_per_page = 10)
    Post.order(created_at: :desc).limit(posts_per_page).offset(page - 1).to_a
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
    self.title.content
  end

  def body
    self.tagged_texts.where('content_type = ?', 'body').first
  end
  def body_text
    body.content
  end

  include PostsHelper
  def facebook_buttons
    fb_buttons_for_post(self)
  end
  def twitter_button
    twitter_button_for_post(self)
  end
end
