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
#  remember_token  :string(255)
#

require 'rails_helper'

RSpec.describe Contributor, :type => :model do
  let(:contributor) { FactoryGirl.create :contributor }

  subject { contributor }
  it { should be_valid }
  it { should respond_to :is_admin }
  its(:is_admin) { should be true }
  it { should respond_to :name }
  it { should respond_to :email }
  its(:email) { should eq('mike@tunetap.com') }
  it { should respond_to :password_digest }
  it { should respond_to :remember_token }
  its(:remember_token) { should be_truthy }

  it 'is not admin by default for everyone except the first' do
    contributor1 = Contributor.create(name: 'Feifan Zhou', email: 'feifan@me.com', password: 'letmein')
    contributor2 = Contributor.create(name: 'Bob Loblaw', email: 'bob@loblaw.com', password: 'letmein')
    expect(contributor1).to be_valid
    expect(contributor1.is_admin).to be true
    expect(contributor2).to be_valid
    expect(contributor2.is_admin).to be false
    # expect(0).to eq(0)
  end

  it 'generates the right slugged path' do
    expect(contributor.path_with_slug).to eq("/contributors/#{ contributor.id }/mike-falb")
  end
end

describe 'Contributor posts' do
  let(:author) { FactoryGirl.create :contributor }
  let(:post1) { FactoryGirl.build :post }
  let(:post2) { FactoryGirl.build :post }

  before :each do
    post1.contributor = author
    post1.save
    post2.contributor = author
    post2.save
  end
  it 'are fetched correctly' do
    posts = author.posts_for_page
    expect(posts.count).to eq(2)
    expect(posts.first.id).to eq(post1.id)
  end
  it 'have the right count' do
    expect(author.number_of_posts).to eq(2)
  end
end
