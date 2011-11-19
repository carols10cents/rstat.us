class AvatarPresenter
  # Constants that are useful for avatars using gravatar
  GRAVATAR               = "gravatar.com"
  DEFAULT_AVATAR         = "avatar.png"
  ENCODED_DEFAULT_AVATAR = URI.encode_www_form_component(DEFAULT_AVATAR)

  def initialize(avatar_holder, template)
    @avatar_holder = avatar_holder
    @template = template
  end

  def avatar
    img = h.image_tag(avatar_url, :class => "photo", :alt => "avatar")
    h.content_tag :div, :class => "avatar" do
      h.link_to img, @avatar_holder.url, :class => "url"
    end
  end

  # Returns a locally useful url for the object's avatar

  # We've got a couple of options here. If the object has an image_url,
  # we use that, and if they don't, we go with Gravatar using the object's
  # email. If none of that is around, then we show the DEFAULT_AVATAR.

  def avatar_url
    # If the object has an image_url, return it
    if @avatar_holder.image_url.present?
      @avatar_holder.image_url

    # If the object has an email, look for a gravatar url.
    elsif @avatar_holder.email.present?
      gravatar_url(@avatar_holder.email)

    # Otherwise return the default avatar
    else
      h.asset_path(DEFAULT_AVATAR)
    end
  end

  private

  # Return the gravatar url
  # Query described [here](http://en.gravatar.com/site/implement/images/#default-image).
  def gravatar_url(email)
    email_digest = Digest::MD5.hexdigest email
    "http://#{GRAVATAR}/avatar/#{email_digest}?s=48&r=r&d=#{ENCODED_DEFAULT_AVATAR}"
  end

  def h
    @template
  end

end