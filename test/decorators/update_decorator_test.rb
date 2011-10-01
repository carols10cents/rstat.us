require_relative '../test_helper'
require 'mocha'

describe UpdateDecorator do
  include TestHelper

  describe "#reply" do
    it "creates a reply link" do
      mock_update = Update.new
      mock_update.stubs(:id).returns("1234")

      u = UpdateDecorator.decorate(mock_update)
      assert_equal "<a class=\"reply\" href=\"?reply=1234\">reply</a>", u.reply
    end
  end

end
