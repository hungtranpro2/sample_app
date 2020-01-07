class User < ApplicationRecord
  validates :email, format: {with: Settings.valid_email_regex}, presence: true,
    length: {maximum: Settings.max_email}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_pass}
  validates :name, presence: true, length: {maximum: Settings.max_name}
  before_save :email_downcase
  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end

  private

  def email_downcase
    email.downcase!
  end
end
