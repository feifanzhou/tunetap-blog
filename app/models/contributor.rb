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
  # FIXME — Refactor multisearchable call 
  # and search_content method
  # into separate module
  multisearchable against: :name

  has_many :posts
  has_many :tags
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: 'inviter_id'
  has_one :received_invitation, class_name: 'Invitation', foreign_key: 'recipient_id'

  before_validation { create_remember_token if (self.remember_token.blank? && self.password_digest && defined?(self.password_digest)) }
  before_create { |user| user.email = user.email.downcase }
  before_create { self.is_admin = (Contributor.count < 1) if self.is_admin.nil? }

  # FIXME — Validation tripping things up with more than one contributor
  # validates :is_admin, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :remember_token, presence: true, uniqueness: { case_sensitive: false }

  has_secure_password validations: false # Remove need for confirmation

  def path_with_slug
    return "/contributors/#{ self.id }/#{ self.name.parameterize }"
  end
  
  def posts_for_page(page = 1, posts_per_page = 10, show_deleted = false)
    p = show_deleted ? self.posts : self.posts.where('is_deleted = false')
    p.limit(posts_per_page).offset(page - 1)
  end

  def search_content
    name
  end

  def number_of_posts
    posts.size
  end

  def number_of_tags
    tags.size
  end

  def generate_invitation
    # FIXME — Generate access code in method on Invitation. Cleaner, more testable
    i = Invitation.new(should_be_admin: false, is_accepted: false, access_code: SecureRandom.urlsafe_base64)
    i.inviter = self
    i.save
    return i
  end

  def inviter
    received_invitation.blank? ? nil : received_invitation.inviter
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
