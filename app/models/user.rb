class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]


  has_many :posts, dependent: :destroy
  has_many :votes, dependent: :destroy
  validates :username, uniqueness: true, presence: true

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(username: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0,20]
      )
    end

    user
  end
end
