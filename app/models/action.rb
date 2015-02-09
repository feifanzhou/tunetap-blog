# == Schema Information
#
# Table name: actions
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  count      :integer
#  medium     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Action < ActiveRecord::Base
  belongs_to :post

  validates_presence_of :post_id
  validates_presence_of :count
  validates_presence_of :medium
end
