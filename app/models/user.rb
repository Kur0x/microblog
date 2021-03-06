class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,
           class_name: 'Relationship',
           foreign_key: 'follower_id',
           dependent: :destroy

  has_many :passive_relationships,
           class_name: 'Relationship',
           foreign_key: 'followed_id',
           dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :likes,
           class_name: 'Like',
           foreign_key: 'liked_user_id',
           dependent: :destroy
  has_many :liked_posts, through: :likes

  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true


  # 返回指定字符串的哈希摘要
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # 返回一个随机令牌
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 为了持久保存会话,在数据库中记住用户
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 通用验证函数,返回 true
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 忘记用户
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 激活账户
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 发送激活邮件
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # 设置密码重设相关的属性
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # 发送密码重设邮件
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # 如果密码重设请求超时了,返回 true
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # 返回用户的动态流
  def feed
    following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  # def feed
  #   Micropost.where('user_id IN (?) OR user_id = ?', following_ids, id)
  # end

  # 关注另一个用户
  # def follow(other_user)
  #   active_relationships.create(followed_id: other_user.id)
  # end

  def follow(other_user)
    following << other_user
  end

  # 取消关注另一个用户
  # def unfollow(other_user)
  #   active_relationships.find_by(followed_id: other_user.id).destroy
  # end

  def unfollow(other_user)
    following.delete(other_user)
  end

  # 如果当前用户关注了指定的用户,返回 true
  def following?(other_user)
    following.include?(other_user)
  end


  def like(post)
    likes.create(liked_post_id: post.id)
  end


  def unlike(post)
    likes.find_by(liked_post_id: post.id).destroy
  end


  def like?(post)
    liked_posts.include?(post)
  end

  private

  # 创建并赋值激活令牌和摘要
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
