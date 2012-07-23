class AuthorDecorator < ApplicationDecorator
  decorates :author

  # Creates a div with class avatar that contains the image tag linked
  # to the user's page
  def avatar
    h.content_tag "div", :class => "avatar" do
      h.link_to(
        h.image_tag(
          absolute_avatar_url,
          :class => "photo user-image",
          :alt => "avatar"
        ),
        author.url
      )
    end
  end

  # Make sure we're using the asset path if the user's avatar is the default
  # (local) avatar
  def absolute_avatar_url
    if author.avatar_url.eql? RstatUs::DEFAULT_AVATAR
      h.asset_path(author.avatar_url)
    else
      author.avatar_url
    end
  end

  # Creates a link to the user's website for their profile
  def website_link
    if absolute_website_url.present?
      h.link_to(
        absolute_website_url,
        absolute_website_url,
        :rel => 'website',
        :class => 'url'
      )
    else
      ""
    end
  end

  # adds http:// if it isn't there
  def absolute_website_url
    if author.website.blank?
      nil
    elsif author.website[0,7] == "http://" or author.website[0,8] == "https://"
      author.website
    else
      "http://#{author.website}"
    end
  end
end
