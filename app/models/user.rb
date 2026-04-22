class User < ApplicationRecord
  has_secure_password
  has_many :videos, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  before_save { self.email = email.downcase }
end
