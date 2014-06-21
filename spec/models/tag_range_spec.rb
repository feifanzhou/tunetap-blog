require 'rails_helper'

RSpec.describe TagRange, :type => :model do
  let(:tag_range ) { FactoryGirl.create :tag_range }

  subject { tag_range }
  it { should be_valid }
  it { should respond_to :tagged_text_id }
  it { should respond_to :tag_id }
  it { should respond_to :start }
  it { should respond_to :length }
end
