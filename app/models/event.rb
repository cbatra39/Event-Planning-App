class Event < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_one :event_categories,foreign_key: "event_categories_id", dependent: :delete
  has_many :event_hashtags,foreign_key: "event_id", dependent: :destroy
  has_many :hashtags, through: :event_hashtags

  has_many :like_events
  has_many :liking_users, through: :like_events, source: :user

  validates :title, presence: true
  validates :location, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_date, presence: true
  validates :end_time, presence: true
  validates :description, presence: true
  validates :event_categories_id, presence: true
 
end
