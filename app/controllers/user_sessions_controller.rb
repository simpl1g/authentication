class UserSessionsController < ApplicationController

  def new
    redirect_to current_user if signed_in?
    respond_to do |format|
        format.html
        format.js
    end
  end

  def check_user
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if @user.two_step_auth
        @user.update_activation_code!
        respond_to do |format|
          format.html
          format.js
        end
      else
        sign_in @user
        redirect_to @user
      end
    else
      flash[:notice] = "Wrong Login, Email or Password"
      render :new
    end
  end

  def create
    @user = User.find_by_activation_code(params[:code])
    if @user
      sign_in @user
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:notice] = "Wrong Code or Time Expired  "
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
