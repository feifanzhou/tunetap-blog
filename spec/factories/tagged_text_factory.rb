FactoryGirl.define do
  factory :tagged_text do
    content_type 'artist'
    content 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
    post_id 1
  end
end