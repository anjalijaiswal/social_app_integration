class User < ActiveRecord::Base

  # Validations
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:linkedin]

  # Check for existing account, if not found will create new one
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.first_name + auth.info.last_name
      user.password = Devise.friendly_token[0,20]
    end
  end
end
