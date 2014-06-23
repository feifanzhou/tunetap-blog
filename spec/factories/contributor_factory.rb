# == Schema Information
#
# Table name: contributors
#
#  id              :integer          not null, primary key
#  is_admin        :boolean
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  remember_token  :string(255)
#

FactoryGirl.define do
  factory :contributor do
    is_admin true
    name 'Mike Falb'
    email 'Mike@Tunetap.com'
    password_digest 'gastro'
  end
end
