class UserFollower < ApplicationRecord
  belongs_to :user
  belongs_to :followed_by, class_name: 'User'
  has_many :like_events
  has_many :liked_events, through: :like_events, source: :event
end
