class UserSessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by_login_and_password(params[:login], params[:password])
    if @user
      session[:signed]=@user.id
      redirect_to @user
    else
      @user = User.find_by_email_and_password(params[:email], params[:password])
      if @user
        session[:signed]=@user.id
        redirect_to @user
      else
        render :login
      end
    end
  end

  def destroy
    session[:signed]=nil
    redirect_to root_path
  end

  def signed?
    redirect_to login_path unless session[:signed]
  end
end
