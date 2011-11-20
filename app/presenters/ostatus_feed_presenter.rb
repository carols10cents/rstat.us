class OstatusFeedPresenter
  delegate :atom, :to => :@ostatus_feed

  def initialize(feed, base_uri)
    @base_uri = base_uri
    @feed = feed
    @ostatus_feed = OStatus::Feed.from_data(
      url
    )
  end

  def url
    "#{@base_uri}feeds/#{@feed.id}.atom"
  end
end