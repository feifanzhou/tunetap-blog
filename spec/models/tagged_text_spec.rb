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

  # FIXME — Test tagged_text.to_html
end
