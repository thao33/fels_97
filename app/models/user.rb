class User < ActiveRecord::Base
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

  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 25},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}

  validates :password, length: {minimum: 6}, on: [:create]
  has_attached_file :avatar, styles: {medium: "300x300", thumb: "100x100"},
                     default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  before_save { self.email = email.downcase }

  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

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
    admin
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
end
