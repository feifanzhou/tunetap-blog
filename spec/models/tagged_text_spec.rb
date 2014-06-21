require 'rails_helper'

RSpec.describe TaggedText, :type => :model do
  let(:tagged_text) { FactoryGirl.create :tagged_text }

  subject { tagged_text }
  it { should be_valid }
  it { should respond_to :content_type }
  it { should respond_to :content }
  it { should respond_to :post_id }
end
