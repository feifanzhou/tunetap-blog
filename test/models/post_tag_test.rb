# == Schema Information
#
# Table name: post_tags
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class PostTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
