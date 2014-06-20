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
  belongs_to :tagged_text
  belongs_to :tag

  validates :tagged_text_id, presence: true
  validates :tag_id, presence: true
  validates :start, presence: true, numericality: { only_integer: true }
  validates :length, presence: true, numericality: { only_integer: true }
end
