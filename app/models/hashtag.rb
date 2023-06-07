class Hashtag < ApplicationRecord
 has_many :events, through: :event_hashtags

 has_many :event_hashtags, foreign_key: 'hashtag_id', dependent: :destroy
 
end
