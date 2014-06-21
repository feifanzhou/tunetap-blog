require 'rails_helper'

RSpec.describe Post, :type => :model do
  let(:post) { FactoryGirl.create :post }

  subject { post }
  it { should be_valid }
  it { should respond_to :contributor_id }
  it { should respond_to :player_type }
end
