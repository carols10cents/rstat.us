require_relative '../test_helper'
require 'mocha'

describe UpdateDecorator do
  include TestHelper

  before do
    @mock_update = mock
    @mock_update.stubs(:id).returns("1234")
    @mock_update.stubs(:in_reply_to_username).returns("bert")
    @decorated_mock = UpdateDecorator.decorate(@mock_update)
  end

  describe "#in_reply_to_name" do
    it "shows the name of the person being replied to" do
      in_reply = @decorated_mock.in_reply_to_name
      assert in_reply.has_xpath?("//span[@class='name' and text()='bert']")
    end
  end

  describe "#share" do
    it "creates a share link" do
      share_link = @decorated_mock.share
      assert share_link.has_xpath?("//a[@href='?share=1234' and @class='share' and text()='share']")
    end
  end

  describe "#reply" do
    it "creates a reply link" do
      reply_link = @decorated_mock.reply
      assert reply_link.has_xpath?("//a[@class='reply' and @href='?reply=1234' and text()='reply']")
    end
  end
end
