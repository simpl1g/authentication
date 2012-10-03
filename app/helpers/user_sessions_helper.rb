module UserSessionsHelper
  def sign_in_user(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    delete_user_location
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def get_user_location
    user = User.find(session[:return_to_user])
    user ? user : nil
  end

  def delete_user_location
    session[:return_to_user] = nil
  end

  def store_user_location(user_id)
    session[:return_to_user] = user_id
  end

  def sign_in_and_get_location(user)
    sign_in_user user
    user = get_user_location || user
    delete_user_location

    user
  end

end
