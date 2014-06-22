# == Schema Information
#
# Table name: tagged_texts
#
#  id           :integer          not null, primary key
#  content_type :string(255)
#  content      :text
#  post_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :tagged_text do
    content_type 'title'
    content 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
    post_id 1
  end

  factory :tagged_title, class: TaggedText do
    content_type 'title'
    content 'Lorem ipsum'
    post_id 1
  end
  factory :tagged_body, class: TaggedText do
    content_type 'body'
    content 'son dolore'
    post_id 1
  end
end
