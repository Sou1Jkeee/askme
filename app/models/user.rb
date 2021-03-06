require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new

  attr_accessor :password

  has_many :questions, dependent: :destroy

  validates :email, :username, presence: true, uniqueness: true

  validates :email, format: { with: /\A.+@.+\..+\z/.freeze }
  validates :username, length: { maximum: 40 }, format: { with: /\A\w+\z/.freeze }
  validates :bgcolor, format: { with: /#([a-f\d]{6}|[a-f\d]{3})\z/i.freeze }

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_validation :normalize_username_and_email
  before_save :encrypt_password

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    return nil unless user.present?

    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    return user if user.password_hash == hashed_password

    nil
  end

  private

  def normalize_username_and_email
    self.username&.downcase!
    self.email&.downcase!
  end
end
