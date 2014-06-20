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

class Contributor < ActiveRecord::Base
  include PgSearch
  multisearchable against: :name

  has_many :posts
  has_many :tags

  validates :is_admin, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
end
