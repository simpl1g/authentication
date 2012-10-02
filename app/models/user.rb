class User < ActiveRecord::Base
  attr_accessible :email, :login, :password, :password_confirmation, :two_step_auth, :code, :remember_token
  before_validation :make_role
  before_save :create_remember_token
  before_save :hide_password

  has_one :role, dependent: :destroy
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

    if user && UserHelper.check(pass, user.password)
      user
    else
      nil
    end
  end

  def update_activation_code!
    code = self.codes.build(generated_code: UserHelper.generate_code(self.email))
    code.save
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

      result = user if code && (Time.now - created_at < 32)
    end

    result
  end

  def admin?
    self.role.admin?
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def hide_password
    self.password = BCrypt::Password.create
  end

  def make_role
    build_role
  end

end
