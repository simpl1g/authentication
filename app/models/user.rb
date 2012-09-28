class User < ActiveRecord::Base
  attr_accessible :email, :login, :password, :password_confirmation, :two_step_auth
  before_create :hide_password
  after_create :make_role
  after_create :first_to_admin
  before_update :hide_password
  after_destroy :check_first
  has_one :role, dependent: :destroy

  validates :login, presence: true, uniqueness: true
  validates_confirmation_of :password
  validates :password, presence: true, length: {minimum: 3}
  #validates :password_confirmation, presence: true
  validates :email, :presence => true,
            :uniqueness => true,
            :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  def self.authenticate(login_or_email, pass)
    user = User.find_by_email(login_or_email) || User.find_by_login(login_or_email)
    user ? user : (return false)
    user && UserHelper.check(pass, user.password) ? user : false
  end

  private

  def my_def(login_or_email)
    user = User.find_by_email(login_or_email) || User.find_by_login(login_or_email)
    user ? user : false
  end

  def hide_password
    self.password = UserHelper.update(self.password)
  end

  def make_role
    Role.create(admin: false, user_id: self.id)
    #self.build_role(admin: false)
  end

  def first_to_admin
    Role.first.update_attributes(admin: true) if User.count == 1
  end

  def check_first
    Role.first.update_attributes(admin: true) unless Role.find_by_admin true
  end

end
