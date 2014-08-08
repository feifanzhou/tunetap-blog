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

class Session < ActiveRecord::Base
  before_create :set_initial_values

  def code
    self.session_code
  end

  private
  def set_initial_values
    self.session_code = SecureRandom.urlsafe_base64 if self.session_code.blank?
    self.last_active = DateTime.now if self.last_active.blank?
  end
end
