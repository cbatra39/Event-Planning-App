class EventCategory < ApplicationRecord
    has_many :events,foreign_key:"id",dependent: :delete_all
end
