# == Schema Information
#
# Table name: tag_ranges
#
#  id             :integer          not null, primary key
#  tagged_text_id :integer
#  tag_id         :integer
#  start          :integer
#  length         :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class TagRange < ActiveRecord::Base
  # FIXME — Add constraint that TaggedText cannot have more than one of each tag
  belongs_to :tagged_text
  belongs_to :tag

  validates :tagged_text_id, presence: true, numericality: { greater_than: 0 }
  validates :tag_id, presence: true, numericality: { greater_than: 0 }
  validates :start, presence: true, numericality: { only_integer: true }
  validates :length, presence: true, numericality: { only_integer: true }
  # FIXME — Before save, ensure that start and length are within range of TaggedText
end
