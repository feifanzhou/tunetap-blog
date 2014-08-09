# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  session_id :integer
#  is_deleted :boolean
#  is_upvote  :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
