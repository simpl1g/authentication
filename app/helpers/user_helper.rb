require 'securerandom'
require 'digest/sha2'
module UserHelper

  def link_to_gravatar(email, size=150)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?d=wavatar&s=#{size}"
  end

  def self.update(password)
    salt = self.salt
    hash = self.hash(password,salt)
    self.store(hash, salt)
  end

  def self.check(password, store)
    hash = self.get_hash(store)
    salt = self.get_salt(store)
    if self.hash(password,salt) == hash
      true
    else
      false
    end
  end

  def self.generate_code(email)
    Digest::SHA512.hexdigest("#{email}:#{salt}").gsub(/[a-z]/i,"")[0..5]
  end

  protected

  def self.salt
    SecureRandom.hex(32)
  end

  # Generates a 128 character hash
  def self.hash(password,salt)
    Digest::SHA512.hexdigest("#{password}:#{salt}")
  end

  # Mixes the hash and salt together for storage
  def self.store(hash, salt)
    hash + salt
  end

  # Gets the hash from a stored password
  def self.get_hash(store)
    store[0..127]
  end

  # Gets the salt from a stored password
  def self.get_salt(store)
    store[128..192]
  end

end