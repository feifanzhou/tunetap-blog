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

require 'rails_helper'

RSpec.describe TaggedText, :type => :model do
  let(:tagged_text) { FactoryGirl.create :tagged_text }

  subject { tagged_text }
  it { should be_valid }
  it { should respond_to :content_type }
  it { should respond_to :content }
  it { should respond_to :post_id }

  let(:tag1) { Tag.create(name: 'ipsum', contributor_id: 1, tag_type: 'artist') }
  let(:tag2) { Tag.create(name: 'amet', contributor_id: 1, tag_type: 'artist') }
  it 'produces correct HTML' do
    tr1 = TagRange.new(start: 6, length: 5)
    tr1.tagged_text = tagged_text
    tr1.tag = tag1
    tr1.save
    tr2 = TagRange.new(start: 22, length: 4)
    tr2.tagged_text = tagged_text
    tr2.tag = tag2
    tr2.save
    result = tagged_text.to_html('p')
    expected = "<p class='TaggedText'>Lorem <a href=\"/tags/#{ tag1.id }/ipsum\">ipsum</a> dolor sit <a href=\"/tags/#{ tag2.id }/amet\">amet</a>, consectetur adipisicing elit.</p>"
    expect(result).to eq(expected)
  end
end
