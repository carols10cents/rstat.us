require_relative '../no_rails_test_helper'
require 'mocha'
require 'ostatus'

require_relative '../../../app/presenters/ostatus_feed_presenter'

describe OstatusFeedPresenter do
  before do
    @mock_feed = mock
    @mock_ostatus_feed = mock
    OStatus::Feed.expects(:from_data).returns(@mock_ostatus_feed)
    @presenter = OstatusFeedPresenter.new(@mock_feed, 'http://root-url.com/')
  end

  it "delegates .atom to the OStatus::Feed" do
    @mock_ostatus_feed.expects(:atom).returns("hi")
    @presenter.atom.must_equal("hi")
  end

  describe "#url" do
    it "has an absolute url to the feed" do
      @mock_feed.stubs(:id).returns(3)
      @presenter.url.must_equal("http://root-url.com/feeds/3.atom")
    end
  end

end