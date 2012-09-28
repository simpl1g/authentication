class UserSessionsController < ApplicationController
  include UserSessionsHelper
  def new
    redirect_to user_path(current_user) if signed_in?
  end

  def check_user
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if @user.two_step_auth
        session[:code] = UserHelper.generate_code(@user.email)
        session[:user_to_log] = @user.id
        session[:time] = Time.now
      else
        sign_in @user.id
        redirect_to @user
      end
    else
      flash[:notice] = "Wrong Login, Email or Password"
      render :new
    end
  end

  def create
    if params[:code] == session[:code] && (Time.now - session[:time] < 32)
      sign_in session[:user_to_log]
      clear_session
      redirect_to user_path(session[:signed])
    else
      reset_session
      flash[:notice] = "Wrong Code or Time Expired  "
      clear_session
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
