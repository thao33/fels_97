class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  TEMP_EMAIL_PREFIX = "e-learning"
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token

  has_many :active_relationship,
    class_name: Relationship.name,
    foreign_key: :follower_id,
    dependent: :destroy
  has_many :be_followed,
    class_name: Relationship.name,
    foreign_key: :followed_id,
    dependent: :destroy

  has_many :following, through: :active_relationship, source: :followed
  has_many :followers, through: :be_followed, source: :follower
  has_many :lessons

  # validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: {maximum: 50},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}, on: [:create]
  has_attached_file :avatar, styles: {medium: "300x300", thumb: "100x100"},
                     default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  before_save { self.email = email.downcase }

  # has_secure_password

  def remember
    self.remember_token = User.new_token
    update_attributes! remember_digest: User.digest(remember_token)
  end

  def authenticated?(remember_token)
  	return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attributes! remember_digest: nil
  end

  def admin?
    is_admin
  end

  def following? user
    self.following.include? user
  end

  def follow user
    active_relationship.create followed_id: user.id
  end

  def unfollow user
    active_relationship.find_by(followed_id: user.id).destroy
  end

  def following_count
    following.count
  end

  def followers_count
    followers.count
  end

  class << self
    def find_for_oauth auth, signed_in_resource = nil
      identity = Identity.find_for_oauth auth
      user = signed_in_resource ? signed_in_resource : identity.user
      self.set_user_oauth user, auth if user.nil?
      self.identity_user user, identity
      user
    end

    def set_user_oauth user, auth
      email_is_verified = auth.info.email and
                          (auth.info.verified or auth.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email
      if user.nil?
        name = auth.extra.raw_info.name
        email = email ? email :
                        "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
        user = self.create! name: name, email: email,
                            password: Devise.friendly_token[0, 20]
      end
    end

    def identity_user user, identity
      if identity.user != user
        identity.user = user
        identity.save!
      end
    end

    # Returns the hash digest of the given string.
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def email_verified?
    self.email and self.email !~ VALID_EMAIL_REGEX
  end
end
