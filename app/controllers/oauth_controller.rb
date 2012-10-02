class OauthController < ApplicationController
  def start
    redirect_to client.auth_code.authorize_url(
      :redirect_uri => oauth_callback_url, :scope => 'email'
    )
  end

  def callback
    access_token = client.auth_code.get_token(
      params[:code], :redirect_uri => oauth_callback_url
    )

    session[:fb_user] = JSON.parse access_token.get('/me')
    # in reality you would at this point store the access_token.token value as well as
    # any user info you wanted

    redirect_to :controller => :users, :action => :index, :token => access_token.token

  end

  protected

  def client
    #facebook_settings = YAML::load(File.open("#{Rails.root}/config/oauth.yml"))
    all_oauth_config = YAML.load_file( File.join( Rails.root, 'config', 'oauth.yml' ) )
    facebook_settings = all_oauth_config[Rails.env]['facebook']
    @client ||= OAuth2::Client.new(
      "#{facebook_settings['app_id']}", "#{facebook_settings['app_secret']}",
      :site => 'https://graph.facebook.com'
    )
  end

end
