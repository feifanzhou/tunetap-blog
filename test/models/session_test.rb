# == Schema Information
#
# Table name: sessions
#
#  id           :integer          not null, primary key
#  ip_address   :string(255)
#  session_code :string(255)
#  last_active  :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
