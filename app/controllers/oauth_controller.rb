class OauthController < ApplicationController
  def start
    @oauth= Koala::Facebook::OAuth.new(APP_ID, APP_SECRET,REDIRECT_URI)
    redirect_to @oauth.url_for_oauth_code(:permissions=>"email")
  end

  def callback
    oauth= Koala::Facebook::OAuth.new(APP_ID, APP_SECRET,REDIRECT_URI)
    graph = Koala::Facebook::API.new(oauth.get_access_token(params[:code]))
    @email_and_name = graph.get_object("/me?fields=name,email")
    User.find_or_create_by_email(@email_and_name["email"])
    redirect_to(controller: "users", :action=>"index")
  end

  def destroy

  end

  protected

  def client
    #facebook_settings = YAML::load(File.open("#{Rails.root}/config/oauth.yml"))
    all_oauth_config = YAML.load_file( File.join( Rails.root, 'config', 'oauth.yml' ) )

    @facebook_settings = all_oauth_config[Rails.env]['facebook']
    @client ||= OAuth2::Client.new(
      "#{@facebook_settings['app_id']}", "#{@facebook_settings['app_secret']}",
      :site => 'https://graph.facebook.com'
    )
  end

end
