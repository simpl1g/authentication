module UserSessionsHelper
  def sign_in(user_id)
    session[:signed] = user_id
  end

  def sign_out
    session[:signed] = nil
  end

  def current_user
    session[:signed] if signed_in?
  end

  def signed_in?
    session[:signed] ? true : false
  end

  def clear_session
    session[:code] = session[:time] = session[:user_to_log] = nil
  end
end
