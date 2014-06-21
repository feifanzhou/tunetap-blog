FactoryGirl.define do
  factory :contributor do
    is_admin true
    name 'Mike Falb'
    email 'mike@tunetap.com'
    password_digest 'gastro'
  end
end