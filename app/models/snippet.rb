require 'openssl'
require 'base64'

class Snippet < ApplicationRecord

  belongs_to :user
  validates :content, presence: true
  before_save :encrypt_content
  after_find :decrypt_content

  class << self
    attr_accessor :encryption_key, :encryption_iv

    def encryption_key
      @encryption_key ||= OpenSSL::Random.random_bytes(32)
    end

    def encryption_iv
      @encryption_iv ||= OpenSSL::Random.random_bytes(16)
    end
  end

  private

  def encrypt_content
    cipher = OpenSSL::Cipher.new('AES-256-CFB')
    cipher.encrypt
    cipher.key = self.class.encryption_key
    cipher.iv = self.class.encryption_iv
    encrypted = cipher.update(self.content) + cipher.final
    self.content = Base64.strict_encode64(encrypted)
  end

  def decrypt_content
    decoded_content = Base64.strict_decode64(self.content)
    decipher = OpenSSL::Cipher.new('AES-256-CFB')
    decipher.decrypt
    decipher.key = self.class.encryption_key
    decipher.iv = self.class.encryption_iv
    decrypted = decipher.update(decoded_content)
    decrypted << decipher.final
    self.content = decrypted
  end

end
