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

class Invitation < ActiveRecord::Base
  belongs_to :recipient, class_name: 'Contributor', foreign_key: 'recipient_id'
  belongs_to :inviter, class_name: 'Contributor', foreign_key: 'inviter_id'

  validates :access_code, presence: true
  validates :inviter_id, presence: true, numericality: { greater_than: 0 }

  def is_active?
    # FIXME — Make 1 (day) into a constant or environment variable
    return false if self.created_at.blank?
    (DateTime.now - 1) <= self.created_at
  end

  def is_accepted?
    is_accepted
  end
end
