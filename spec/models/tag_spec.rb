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
#  is_deleted     :boolean
#

require 'rails_helper'

RSpec.describe Tag, :type => :model do
  let(:tag) { FactoryGirl.create :tag }
  
  subject { tag }
  it { should be_valid }
  it { should respond_to :name }
  it { should respond_to :contributor_id }

  it 'generates the right slugged path' do
    expect(tag.path_with_slug).to eq("/tags/#{ tag.id }/lana-del-rey")
  end
end

describe 'Tag' do
  let(:post) { FactoryGirl.create :post }
  let(:tag) { FactoryGirl.create :tag }

  before :each do
    tagged_text = FactoryGirl.build :tagged_text
    tagged_text.post = post
    tagged_text.save
    tag_range = FactoryGirl.build :tag_range
    tag_range.tag = tag
    tag_range.tagged_text = tagged_text
    tag_range.save
  end
  it 'finds its posts' do
    found_post = tag.posts_for_page(1, 10).first
    expect(found_post.id).to eq(post.id)
  end
end
