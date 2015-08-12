class User < ActiveRecord::Base

  has_many :comments
  has_many :posts, through: :comments
  # Validations
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:linkedin, :facebook, :twitter, :google_oauth2, :github]

  # Check for existing account, if not found will create new one
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      #user.name = auth.info.first_name + auth.info.last_name
      user.password = Devise.friendly_token[0,20]
      user.save
    end
  end
end
