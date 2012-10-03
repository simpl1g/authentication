class User < ActiveRecord::Base
  attr_accessible :email, :login, :password, :password_confirmation, :two_step_auth, :code, :remember_token

  before_save :create_remember_token

  has_many :codes

  has_secure_password

  validates :login, presence: true, uniqueness: true
  validates_confirmation_of :password
  validates :password, presence: true, length: {minimum: 3}
  #validates :password_confirmation, presence: true
  validates :email, :presence => true,
            :uniqueness => true,
            :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  self.per_page = 10

  def self.authenticate(login_or_email, pass)
    user = User.find_by_email(login_or_email) || User.find_by_login(login_or_email)
    if user && user.check_password(pass)
      user
    else
      nil
    end
  end

  def check_password(unencrypted_password)
    BCrypt::Password.new(self.password_digest) == unencrypted_password
  end

  def update_activation_code!
    code = self.codes.build(generated_code: generate_code(self.email))
    code.save
  end

  def generate_code(email)
    Digest::SHA512.hexdigest("#{email}:#{salt}").gsub(/[a-z]/i, "")[0..5]
  end

  def salt
    SecureRandom.hex(32)
  end

  def get_activation_code
    self.codes.last.generated_code
  end

  def self.find_by_activation_code code
    code = Code.find_by_generated_code(code)
    result = nil

    if code
      user = code.user
      created_at = code.created_at
      code.destroy

      result = user if user && (Time.now - created_at < 32)
    end

    result
  end

  def self.find_from_facebook(opts)
    user = User.find_by_email(opts["email"])
    if user

      return user
    else

      return User.create(login: opts["name"], email: opts["email"], password: BCrypt::Password.create(rand 999999), two_step_auth: true)
    end
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
