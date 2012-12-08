class OauthController < ApplicationController
  before_filter :oauth
  
  def start
    redirect_to @oauth.url_for_oauth_code(:permissions=>"email")
  end

  def callback
    if params[:error]
      redirect_to login_path, :notice => params[:error_description]
    else
      graph = Koala::Facebook::API.new(@oauth.get_access_token(params[:code]))
      email_and_name = graph.get_object("/me?fields=name,email")
      @user = sign_in_and_get_location User.find_from_facebook(email_and_name)
      redirect_to @user
    end
  end
  
  private

  def oauth
    @oauth ||= Koala::Facebook::OAuth.new(APP_ID, APP_SECRET,REDIRECT_URI)
  end

end
