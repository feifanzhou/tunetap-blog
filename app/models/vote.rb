# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  session_id :integer
#  is_deleted :boolean
#  is_upvote  :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
  belongs_to :post
  belongs_to :session
end
