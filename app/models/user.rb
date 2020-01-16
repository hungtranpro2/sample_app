class User < ApplicationRecord
  validates :email, format: {with: Settings.valid_email_regex}, presence: true,
    length: {maximum: Settings.max_email}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_pass},
    allow_nil: true
  validates :name, presence: true, length: {maximum: Settings.max_name}
  attr_accessor :remember_token
  before_save :email_downcase
  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def email_downcase
    email.downcase!
  end
end
