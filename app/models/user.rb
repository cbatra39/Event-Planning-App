class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_one :profile
  has_many :events
  has_many :favourite_events
  has_many :user_followers
  
  
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

         validates :email, presence: true, uniqueness: true
        
  def jwt_payload
    super
  end
end
