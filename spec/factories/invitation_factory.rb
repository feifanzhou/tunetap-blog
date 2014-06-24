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
#

FactoryGirl.define do
  factory :invitation do
    access_code 'letmein'
    recipient_id 1
    inviter_id 1
    should_be_admin false
  end
end