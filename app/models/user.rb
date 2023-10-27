class User < ApplicationRecord

  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, :omniauthable, jwt_revocation_strategy: self, omniauth_providers: %i[google_oauth2]
  has_many :snippets

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(
         email: data['email'],
         password: Devise.friendly_token[0,20]
      )
    end
    user
  end

  def self.from_internal_login(email, password)
    user = User.find_by(email: email)
    return nil unless user
    return user if user.valid_password?(password)

    nil
  end

end

