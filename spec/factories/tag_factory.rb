# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  contributor_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  tag_type       :string(255)
#

FactoryGirl.define do
  factory :tag do
    name 'Lana del Rey'
    description 'Grant'
    contributor_id 1
    tag_type 'artist'
  end
end
