class Profile < ApplicationRecord
    has_one_attached :image
    belongs_to :user

    validates :first_name, presence: true, format: { with: /\A[A-Z][a-zA-Z]+\z/, message: "should start with a capital letter and only contain letters" }
    validates :last_name, presence: true, format: { with: /\A[A-Z][a-zA-Z]+\z/, message: "should start with a capital letter and only contain letters" }
    validates :dob, presence: true
    
end
