require_relative '../no_rails_test_helper'
require 'mocha'
require 'ostatus'

require_relative '../../../app/presenters/ostatus_feed_presenter'

describe OstatusFeedPresenter do
  before do
    @mock_author = stub_everything("author")
    @mock_feed = stub_everything("feed", :author => @mock_author)

    @mock_ostatus_feed = mock
    @mock_template = FakeTemplate.new

    OStatus::Feed.expects(:from_data).returns(@mock_ostatus_feed)
    @presenter = OstatusFeedPresenter.new(@mock_feed, @mock_template)
  end

  it "delegates .atom to the OStatus::Feed" do
    @mock_ostatus_feed.expects(:atom).returns("hi")
    @presenter.atom.must_equal("hi")
  end

  describe "#url" do
    it "has an absolute url to the feed" do
      @mock_feed.stubs(:id).returns(3)
      @presenter.url.must_equal("http://example.com/feeds/3.atom")
    end
  end

  describe "#title" do
    it "makes a pretty title" do
      @mock_feed.stubs(:username).returns("PookieWookums")
      @presenter.title.must_equal("PookieWookums's Updates")
    end
  end

  describe "#logo_url" do
    it "returns an absolute url to the avatar using an avatar presenter" do
      avatar_url = "http://example.com/images/avatar.png?123"

      mock_avatar_presenter = mock
      mock_avatar_presenter.
        expects(:absolute_avatar_url).
        with("http://example.com/").
        returns(avatar_url)
      AvatarPresenter.expects(:new).returns(mock_avatar_presenter)

      @presenter.logo_url.must_equal(avatar_url)
    end
  end
end