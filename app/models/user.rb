class User < ActiveRecord::Base
  # mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :lockable, :omniauthable, :confirmable,
    omniauth_providers: [:google_oauth2, :facebook]
  mount_uploader :avatar, AvatarUploader
  has_many :lessons, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
    foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  validate :avatar_size
  def self.new_with_session params, session
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
    end
  end


  def self.monthly_email
    @users = User.all
    @users.each do |user|
      wordcount = user.lessons.recent(1.month.ago).results.word.size
      LessonMailer.monthly_email user.email, wordcount
    end
  end
  private
  def avatar_size
    if avatar.size > 5.megabytes
      errors.add(:avatar, "should be less than 5MB")
    end
  end
end
