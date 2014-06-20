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

  has_many :tagged_texts, through: :tag_ranges
  belongs_to :contributor

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :contributor_id, presence: true

  def creator
    return self.contributor
  end
end
