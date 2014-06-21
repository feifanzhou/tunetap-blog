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
#

class Tag < ActiveRecord::Base
  include PgSearch
  multisearchable against: :name

  has_many :tag_ranges
  has_many :tagged_texts, through: :tag_ranges
  has_many :posts, -> { uniq }, through: :tagged_texts
  belongs_to :contributor

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :contributor_id, presence: true, numericality: { greater_than: 0 }

  def creator
    return self.contributor
  end

  include PostHelper
  def posts_for_page(page = 1, posts_per_page = 10)
    get_posts_by_tag(self, page, posts_per_page)
  end
end
