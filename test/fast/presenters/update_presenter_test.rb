require_relative '../no_rails_test_helper'
require 'mocha'

require_relative '../../../app/presenters/update_presenter'

describe UpdatePresenter do
  before do
    @mock_update = mock
    @mock_update.stubs(:id).returns("1234")
    @mock_update.stubs(:in_reply_to_username).returns("bert")

    @mock_template = FakeTemplate.new

    @presenter = UpdatePresenter.new(@mock_update, @mock_template)
  end

  describe "#content" do
    it "returns the text of the update in a div" do
      status = "This is the USS Enterprise, Captain Jean Luc Picard"
      @mock_update.stubs(:to_html).returns(status)

      assert @presenter.content.has_xpath?(
        "//div[@class='entry-content' and text()='#{status}']"
      )
    end
  end

  describe "#metadata" do
    before do
      @published_time = Date.parse()

      @mock_template.stubs(:time_ago_in_words).returns("22 hours")
      @mock_update.stubs(:created_at).returns(Date.parse("2011-01-01"))
      @mock_update.stubs(:url).returns("/update/123")
      @mock_update.stubs(:referral)
      @mock_update.stubs(:referral_url)
      @metadata = @presenter.metadata
    end

    it "has a time tag" do
      assert @metadata.has_xpath?(
        "//time[@class='published' and @pubdate='pubdate' and @datetime='2011-01-01']"
      )
    end

    it "has a permalink" do
      assert @metadata.has_xpath?(
        "//a[@rel='bookmark' and @href='/update/123' and text()='22 hours ago']"
      )
    end

    describe "in reply to" do
      it "doesnt say 'in reply to' if it isnt replying to anything" do
        refute @metadata.has_xpath?("//a[contains(text(), 'in reply to')]")
      end

      it "does say 'in reply to' with a username if there's a referral" do
        @mock_referring_update = mock
        @mock_referring_update.stubs(:id).returns(7)
        @mock_referring_update.stubs(:username).returns("oogabooga")
        @mock_update.stubs(:referral).returns(@mock_referring_update)

        in_reply_to = @presenter.metadata

        assert in_reply_to.has_xpath?(
          "//span[@class='in-reply']/a[@href='/updates/7' and contains(text(), 'in reply to')]/span[@class='name' and text()='oogabooga']"
        )
      end

      it "does say 'in reply to this update' without a username if there's a referral url" do
        @mock_update.stubs(:referral_url).returns("http://identi.ca/notice/123")

        in_reply_to = @presenter.metadata

        assert in_reply_to.has_xpath?(
          "//span[@class='in-reply']/a[@href='http://identi.ca/notice/123' and contains(text(), 'in reply to this update')]"
        )
      end
    end
  end

  describe "#actions" do
    describe "no logged in user" do
      it "does not return anything for actions" do
        @mock_template.stubs(:current_user).returns(nil)
        assert_equal "", @presenter.actions
      end
    end

    describe "logged in user looking at their own update" do
      before do
        @mock_template.stubs(:current_user).returns(mock)
        @mock_update.stubs(:made_by?).returns(true)
        @action_output = @presenter.actions
      end

      it "has a delete link" do
        assert @action_output.has_xpath?(
          "//input[@class='remove-update' and @value='I Regret This']"
        )
      end

      it "does not have a share link" do
        refute @action_output.has_xpath?(
          "//a[text()='share']"
        )
      end

      it "does not have a reply link" do
        refute @action_output.has_xpath?(
          "//a[text()='reply']"
        )
      end
    end

    describe "logged in user looking at someone else's update" do
      before do
        @mock_template.stubs(:current_user).returns(mock)
        @mock_update.stubs(:made_by?).returns(false)
        @action_output = @presenter.actions
      end

      it "has a share link" do
        assert @action_output.has_xpath?(
          "//a[text()='share']"
        )
      end

      it "has a reply link" do
        assert @action_output.has_xpath?(
          "//a[text()='reply']"
        )
      end

      it "does not have a delete link" do
        refute @action_output.has_xpath?(
          "//input[@class='remove-update' and @value='I Regret This']"
        )
      end
    end
  end
end

