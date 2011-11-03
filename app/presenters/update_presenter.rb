class UpdatePresenter

  def initialize(update, template)
    @update = update
    @template = template
  end

  def content
    h.content_tag :div, :class => "entry-content" do
      @update.to_html.html_safe
    end
  end

  def metadata
    time_tag + in_reply_to_link
  end

  def actions
    if h.current_user
      h.content_tag :div, :class => "actions" do
        if @update.made_by?(h.current_user)
          delete_form
        else
          share + " | " + reply
        end
      end
    else
      ""
    end
  end

  private

  def time_tag
    h.content_tag :div, :class => "info" do
      published_time
    end
  end

  def published_time
    h.content_tag :time,
                  :class => "published",
                  :pubdate => "pubdate",
                  :datetime => @update.created_at.iso8601 do
      permalink(h.time_ago_in_words(@update.created_at) + " ago")
    end
  end

  def permalink(link_text)
    h.link_to link_text,
              @update.url,
              :rel => "bookmark"
  end

  def in_reply_to_link
    if !@update.referral.nil?
      h.content_tag :span, :class => "in-reply" do
        h.link_to "in reply to #{username_replying_to}".html_safe,
                  "/updates/#{@update.referral.id}"
      end
    elsif !@update.referral_url.nil?
      h.content_tag :span, :class => "in-reply" do
        h.link_to "in reply to this update", @update.referral_url
      end
    else
      ""
    end
  end

  def share
    h.link_to "share", "?share=#{@update.id}", :class => "share"
  end

  def reply
    h.link_to "reply", "?reply=#{@update.id}", :class => "reply"
  end

  def delete_form
    h.form_tag "/updates/#{@update.id}", :method => "delete" do
      h.tag :input,
            :class => "remove-update",
            :type  => "submit",
            :value => "I Regret This"
    end
  end

  def username_replying_to
    h.content_tag :span, :class => "name" do
      @update.referral.username
    end
  end

  def h
    @template
  end
end