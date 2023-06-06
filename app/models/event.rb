class Event < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_one :event_categories
  has_many :event_hashtags
  has_many :hashtags, through: :event_hashtags

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
