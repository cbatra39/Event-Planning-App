class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_one :profile, foreign_key: 'user_id', dependent: :destroy

  has_many :events

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

         validates :email, presence: true, uniqueness: true
        
 
  def jwt_payload
    super
  end
end
