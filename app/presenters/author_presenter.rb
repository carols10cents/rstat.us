class AuthorPresenter
  # Constants that are useful for avatars using gravatar
  GRAVATAR               = "gravatar.com"
  DEFAULT_AVATAR         = "avatar.png"
  ENCODED_DEFAULT_AVATAR = URI.encode_www_form_component(DEFAULT_AVATAR)

  def initialize(author, template)
    @author = author
    @template = template
  end

  def vcard
    h.content_tag :div, :class => "author vcard" do
      avatar + name_info
    end
  end

  def avatar
    img = h.image_tag(avatar_image_url, :class => "photo", :alt => "avatar")
    h.content_tag :div, :class => "avatar" do
      h.link_to img, @author.url, :class => "url"
    end
  end

  # Returns a locally useful url for the Author's avatar

  # We've got a couple of options here. If they have some sort of image from
  # Twitter, we use that, and if they don't, we go with Gravatar.
  # If none of that is around, then we show the DEFAULT_AVATAR
  def avatar_url
    # If the user has a twitter image, return it
    if @author.image_url.present?
      @author.image_url

    # If the user has an email (Don't they have to?), look for a gravatar url.
    elsif @author.email.present?
      gravatar_url

    # Otherwise return the default avatar
    else
      DEFAULT_AVATAR
    end
  end

  def name_info
    h.content_tag "span", :class => "fn" do
      h.link_to @author.url, :class => "url" do
        (@author.display_name + " (" + nickname + ")").html_safe
      end
    end
  end

  def bio
    h.content_tag "div", :class => "bio" do
      @author.bio
    end
  end

  private

  def nickname
    h.content_tag "span", :class => "nickname" do
      @author.username
    end
  end

  def avatar_image_url
    if avatar_url == DEFAULT_AVATAR
      h.asset_path(avatar_url)
    else
      avatar_url
    end
  end

  # Return the gravatar url
  # Query described [here](http://en.gravatar.com/site/implement/images/#default-image).
  def gravatar_url
    email_digest = Digest::MD5.hexdigest @author.email
    "http://#{GRAVATAR}/avatar/#{email_digest}?s=48&r=r&d=#{ENCODED_DEFAULT_AVATAR}"
  end

  def h
    @template
  end

end