module UserHelper

  def link_to_gravatar(email, size=150)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?d=wavatar&s=#{size}"
  end

end