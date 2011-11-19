require_relative '../no_rails_test_helper'
require 'mocha'

require_relative '../../../app/presenters/avatar_presenter'

describe AvatarPresenter do
  before do
    @mock_author = mock
    @mock_template = FakeTemplate.new

    @presenter = AvatarPresenter.new(@mock_author, @mock_template)
  end

  describe "#avatar" do
    it "should display the author's avatar" do
      @mock_author.stubs(:url).returns("http://rstat.us/users/some_user")
      @mock_author.stubs(:image_url).returns(
        "https://s3.amazonaws.com/some.jpg"
      )

      avatar = @presenter.avatar

      assert avatar.has_xpath?(
        "//div[@class='avatar']"
      )
      assert avatar.has_xpath?(
        "//div/a[@class='url' and @href='http://rstat.us/users/some_user']"
      )

      assert avatar.has_xpath?(
        "//div/a/img[@class='photo' and @alt='avatar' and @src='https://s3.amazonaws.com/some.jpg']"
      )
    end
  end

  describe "#avatar_url" do
    it "returns image_url as avatar_url if image_url is set" do
      image_url = 'http://example.net/cool-avatar'
      @mock_author.stubs(:image_url).returns(image_url)

      @presenter.avatar_url.must_equal(image_url)
    end

    it "returns a gravatar if there is an email and image_url is not set" do
      @mock_author.stubs(:image_url)
      @mock_author.stubs(:email).returns("jamecook@gmail.com")

      @presenter.avatar_url.must_match("http://gravatar.com/")
    end

    it "uses the default avatar if neither image_url nor email is set" do
      @mock_author.stubs(:image_url)
      @mock_author.stubs(:email)

      assert_equal AvatarPresenter::DEFAULT_AVATAR, @presenter.avatar_url
    end
  end
end