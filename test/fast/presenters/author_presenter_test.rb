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

    it "uses an AvatarPresenter and calls name_info" do
      mock_avatar_presenter = mock
      AvatarPresenter.expects(:new).returns(mock_avatar_presenter)

      mock_avatar_presenter.expects(:avatar).returns("")
      @presenter.expects(:name_info).returns("")

      @presenter.vcard
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