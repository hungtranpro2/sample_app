class User < ApplicationRecord

  validates :email, format: {with: Settings.valid_email_regex}, presence: true,
   length: {maximum: Settings.max_email}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_pass}
  validates :name, presence: true, length: {maximum: Settings.max_name}
  before_save :email_downcase
  has_secure_password

  private

  def email_downcase
    email.downcase!
  end
end
