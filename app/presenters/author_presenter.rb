class AuthorPresenter

  def initialize(author, template)
    @author = author
    @template = template
  end

  def vcard
    h.content_tag :div, :class => "author vcard" do
      (AvatarPresenter.new(@author, @template).avatar + name_info).html_safe
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

  def h
    @template
  end

end