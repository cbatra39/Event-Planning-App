class Profile < ApplicationRecord
    has_one_attached :image
    belongs_to :user

    validates :first_name, presence: true, format: { with: /\A[A-Z][a-zA-Z]+\z/ }
    validates :last_name, presence: true, format: { with: /\A[A-Z][a-zA-Z]+\z/}
    validates :dob, presence: true
    validate :image_format
    def image_format
        return unless image.attached?
    
        unless image.content_type.in?(%w[image/jpeg image/png])
            errors.add(:image, "Image format is not correct. Only JPEG and PNG formats are allowed.")
        end
      end
     
end
