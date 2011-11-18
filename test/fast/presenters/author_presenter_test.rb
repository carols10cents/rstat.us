require_relative '../no_rails_test_helper'
require 'mocha'

require_relative '../../../app/presenters/author_presenter'

describe AuthorPresenter do
  before do
    @mock_author = mock
    @mock_template = FakeTemplate.new

    @presenter = AuthorPresenter.new(@mock_author, @mock_template)
  end

  describe "#vcard" do
    it "should be contained within a div of class author and vcard" do
      @mock_author.stubs(:image_url).returns(
        "https://s3.amazonaws.com/some.jpg"
      )
      @mock_author.stubs(:url).returns("")
      @mock_author.stubs(:display_name).returns("")
      @mock_author.stubs(:username).returns("")

      vcard = @presenter.vcard
      assert vcard.has_xpath?(
        "//div[contains(@class, 'author') and contains(@class, 'vcard')]"
      )
    end

    it "calls avatar and name_info" do
      @presenter.expects(:avatar).returns("")
      @presenter.expects(:name_info).returns("")
      @presenter.vcard
    end
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

      assert_equal AuthorPresenter::DEFAULT_AVATAR, @presenter.avatar_url
    end
  end

  describe "#name_info" do
    it "returns name and username" do
      @mock_author.stubs(:url).returns("http://rstat.us/users/some_user")
      @mock_author.stubs(:display_name).returns("Marilyn Monroe")
      @mock_author.stubs(:username).returns("marilyn_monroe")

      name_info = @presenter.name_info

      assert name_info.has_xpath?(
        "//span[@class='fn']"
      )
      assert name_info.has_xpath?(
        "//span/a[@class='url' and @href='http://rstat.us/users/some_user']"
      )
      assert name_info.has_xpath?(
        "//span/a[contains(text(), 'Marilyn Monroe')]"
      )
      assert name_info.has_xpath?(
        "//span/a/span[@class='nickname' and text()='marilyn_monroe']"
      )
    end
  end

  describe "#bio" do
    it "returns bio" do
      bio_text = "I have hobbies, really I do"
      @mock_author.stubs(:bio).returns(bio_text)

      bio = @presenter.bio

      assert bio.has_xpath?("//div[@class='bio' and text()='#{bio_text}']")
    end
  end
end