# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  contributor_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  tag_type       :string(255)
#

class Tag < ActiveRecord::Base
  include PgSearch
  multisearchable against: :name

  has_many :tag_ranges
  has_many :tagged_texts, through: :tag_ranges
  # has_many :posts, -> { uniq }, through: :tagged_texts
  has_many :post_tags
  has_many :posts, through: :post_tags
  belongs_to :contributor

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :contributor_id, presence: true, numericality: { greater_than: 0 }
  validates :tag_type, presence: true, inclusion: { in: ['artist', 'genre', 'other'] }

  def self.from_name(name)
    current_tag = Tag.where('lower(name) = ?', name.downcase).first
    current_tag || Tag.new(name: name)
  end
  def self.create_or_find_by_name(name, contributor, type='other')
    res = Tag.from_name(name)
    unless res.id.blank?
      return res
    else
      res.contributor = contributor
      res.tag_type = type
      res.save
      return res
    end
  end

  def creator
    return self.contributor
  end

  def length
    return self.name.length
  end

  def search_content
    name
  end

  def path_with_slug
    return "/tags/#{ self.id }/#{ self.name.parameterize }"
  end

  include PostsHelper
  def posts_for_page(page = 1, posts_per_page = 10)
    get_posts_by_tag(self, page, posts_per_page)
  end

  # Extend to use with class method
  # http://stackoverflow.com/a/6300506/472768
  extend TagsHelper
  def self.match_with(query)
    tags_like(query)
  end

  def as_json(options={})
    super(options).merge(contributor_name: self.contributor.name, path_with_slug: self.path_with_slug, post_count: self.posts.count)
  end

  include TagsHelper
  def to_link
    link_to_tag self
  end
end
