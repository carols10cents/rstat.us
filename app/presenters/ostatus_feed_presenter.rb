class OstatusFeedPresenter
  delegate :atom, :to => :@ostatus_feed

  def initialize(feed, template)
    @template = template
    @feed = feed
    @ostatus_feed = OStatus::Feed.from_data(
      url,
      :title => title,
      :logo => logo_url
    )
  end

  def url
    "#{h.root_url}feeds/#{@feed.id}.atom"
  end

  def title
    "#{@feed.username}'s Updates"
  end

  def logo_url
    AvatarPresenter.new(@feed.author, h).absolute_avatar_url(h.root_url)
  end

  private

  def h
    @template
  end
end