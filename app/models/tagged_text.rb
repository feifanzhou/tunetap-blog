# == Schema Information
#
# Table name: tagged_texts
#
#  id           :integer          not null, primary key
#  content_type :string(255)
#  content      :text
#  post_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class TaggedText < ActiveRecord::Base
  include PgSearch
  multisearchable against: :content

  # FIXME — Each TaggedText cannot have more than one of each tag
  has_many :tag_ranges
  has_many :tags, through: :tag_ranges
  belongs_to :post

  validates :content_type, presence: true, inclusion: { in: ['artist'] }
  validates :content, presence: true
  validates :post_id, presence: true, numericality: { greater_than: 0 }
end
