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

class Contributor < ActiveRecord::Base
  include PgSearch
  multisearchable against: :name

  has_many :posts
  has_many :tags

  before_create { create_remember_token if (self.remember_token.blank? && self.password_digest && defined?(self.password_digest)) }
  before_create { |user| user.email = user.email.downcase }

  validates :is_admin, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  # FIXME — Remember token validation not working
  # validates :remember_token, presence: true, uniqueness: { case_sensitive: false }

  has_secure_password validations: false # Remove need for confirmation

  def path_with_slug
    return "/contributors/#{ self.id }/#{ self.name.parameterize }"
  end
  
  def posts_for_page(page = 1, posts_per_page = 10)
    return self.posts.limit(posts_per_page).offset(page - 1)
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
