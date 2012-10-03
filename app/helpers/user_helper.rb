module UserHelper

  def link_to_gravatar(email, size=150)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?d=wavatar&s=#{size}"
  end

  def link_to_user(user)
    if signed_in?
      link_to "Show", user_path(user), class: 'btn'
    else
      link_to "Show", user_path(user), class: 'btn', remote: true
    end
  end

end