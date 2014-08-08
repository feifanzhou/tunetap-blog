# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  access_code     :string(255)
#  recipient_id    :integer
#  inviter_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  should_be_admin :boolean
#  is_accepted     :boolean
#

require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
