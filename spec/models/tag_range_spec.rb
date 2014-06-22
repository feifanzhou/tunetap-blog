# == Schema Information
#
# Table name: tag_ranges
#
#  id             :integer          not null, primary key
#  tagged_text_id :integer
#  tag_id         :integer
#  start          :integer
#  length         :integer
#  created_at     :datetime
#  updated_at     :datetime
#

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
