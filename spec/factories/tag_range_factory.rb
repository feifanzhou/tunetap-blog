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

FactoryGirl.define do
  factory :tag_range do
    tagged_text_id 1
    tag_id 1
    start 6
    length 12
  end
end
