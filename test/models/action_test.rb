# == Schema Information
#
# Table name: actions
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  count      :integer
#  medium     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
