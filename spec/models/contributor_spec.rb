# == Schema Information
#
# Table name: contributors
#
#  id              :integer          not null, primary key
#  is_admin        :boolean
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

RSpec.describe Contributor, :type => :model do
  let(:contributor) { FactoryGirl.create :contributor }

  subject { contributor }
  it { should be_valid }
  it { should respond_to :is_admin }
  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
end

describe 'Contributor' do
  let(:author) { FactoryGirl.create :contributor }
  let(:post1) { FactoryGirl.build :post }
  let(:post2) { FactoryGirl.build :post }

  before :each do
    post1.contributor = author
    post1.save
    post2.contributor = author
    post2.save
  end
  it 'finds its posts' do
    posts = author.posts_for_page
    expect(posts.count).to eq(2)
    expect(posts.first.id).to eq(post1.id)
  end
end
