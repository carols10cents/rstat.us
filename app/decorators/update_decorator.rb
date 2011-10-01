class UpdateDecorator < ApplicationDecorator
  decorates :update

  def entry_content
    h.content_tag :div, :class => "entry_content" do
      model.to_html.html_safe
    end
  end

  def author_vcard
    h.content_tag :div, :class => "author vcard" do
      author_avatar + author_link
    end
  end

  def author_avatar
    h.content_tag :div, :class => "avatar" do
      h.content_tag( :a, :class => "url", :href => author_url) do
        h.image_tag author_avatar_url, :class => "photo", :alt => "avatar"
      end
    end
  end

  def author_link
    h.content_tag :span, :class => "fn" do
      h.content_tag :a, :class => "url", :href => author_url do
        model.author.display_name.html_safe + " (" + nickname.html_safe + ")"
      end
    end
  end

  def nickname
    h.content_tag(:span, :class => "nickname") do
      model.author.username
    end
  end

  # Do I make Update#author_url or do this here?
  def author_url
    model.author.url
  end

  def author_avatar_url
    model.author.avatar_url
  end

  def published_metadata
    h.content_tag :div, :class => "info" do
      h.content_tag :time,
                    :class => "published",
                    :pubdate => "pubdate",
                    :datetime => model.created_at.iso8601 do
        permalink
      end
    end
  end

  def permalink
    h.content_tag(:a, :href => model.url, :rel => "bookmark") do
      time_ago
    end
  end

  def time_ago
    h.time_ago_in_words(model.created_at) + " ago"
  end

  def in_reply_to
    if !model.referral.nil?
      h.content_tag :span, :class => "in-reply" do
        h.content_tag :a, :href => "/updates/#{model.referral.id}" do
          "in reply to".html_safe + in_reply_to_name.html_safe
        end
      end
    elsif !model.referral_url.nil?
      h.content_tag :span, :class => "in-reply" do
        h.content_tag :a, :href => model.referral_url do
          "in reply to" #nobady?????
        end
      end
    end
  end

  def in_reply_to_name
    h.content_tag :span, :class => "name" do
      "#{model.referral.author.username}"
    end
  end

  def share
    h.content_tag :a, :class => "share", :href => "?share=#{model.id}" do
      "share"
    end
  end

  def reply
    h.content_tag :a, :class => "reply", :href => "?reply=#{model.id}" do
      "reply"
    end
  end
end