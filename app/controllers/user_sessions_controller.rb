class UserSessionsController < ApplicationController
  def new
    redirect_to user_path(session[:signed]) if session[:signed]
  end

  def check_user
    @user = User.find_by_login_or_email(params[:login])
    if @user
      if UserHelper.check(params[:password], @user.password)
        if @user.two_step_auth
          session[:code] = UserHelper.generate_code(@user.email)
          session[:user_to_log] = @user.id
          session[:time] = Time.now
        else
          session[:signed] = @user.id
          redirect_to @user
        end
      else
        flash[:notice] = "Wrong Login, Email or Password"
        render :new
      end
    else
      flash[:notice] = "Wrong Login, Email or Password"
      render :new
    end
  end

  def create
    if params[:code] == session[:code] && (Time.now - session[:time] < 32)
      session[:signed] = session[:user_to_log]
      session[:code] = session[:time] = session[:user_to_log] = nil
      redirect_to user_path(session[:signed])
    else
      flash[:notice] = "Wrong Code or Time Expired  "
      session[:code] = session[:time] = session[:user_to_log] = nil
      redirect_to root_path
    end
  end

  def destroy
    session[:signed]=nil
    redirect_to root_path
  end

end
