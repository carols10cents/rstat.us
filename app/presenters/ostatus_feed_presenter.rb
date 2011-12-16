class OstatusFeedPresenter
  delegate :atom, :to => :@ostatus_feed

  def initialize(feed, base_uri)
    @base_uri = base_uri
    @feed = feed
    @ostatus_feed = OStatus::Feed.from_data(
      url,
      :title => title,
      :logo => logo
    )
  end

  def url
    "#{@base_uri}feeds/#{@feed.id}.atom"
  end

  def title
    "#{@feed.username}'s Updates"
  end

  def logo
    AvatarPresenter.new(@feed.author).absolute_avatar_url(@base_uri)
  end
end