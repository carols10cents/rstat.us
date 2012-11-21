require_relative '../test_helper'

describe AuthorDecorator do
  include TestHelper
  before do
    @author = AuthorDecorator.decorate(Author.new)
  end

  describe '#website_link' do
    it 'returns link to authors website' do
      @author.website = "http://example.com"
      @author.website_link.must_match('http://example.com')
    end

    it 'returns link to authors website when website has no http prefix' do
      @author.website = 'test.com'
      @author.website_link.must_match('http://test.com')
    end

    it "returns empty string if the author doesn't have a website" do
      @author.website = nil
      @author.website_link.must_equal("")
    end
  end

  describe "#absolute_website_url" do
    it 'returns url to authors website' do
      @author.website = "http://example.com"
      @author.absolute_website_url.must_equal('http://example.com')
    end

    it 'returns url to authors website when website is without http prefix' do
      @author.website = 'test.com'
      @author.absolute_website_url.must_equal('http://test.com')
    end

    it "returns nil if the author doesn't have a website" do
      @author.website = nil
      @author.absolute_website_url.must_equal(nil)
    end
  end

  describe "#avatar" do
    it "has a link to the author's page around the author's image" do
      @avatar_html = Nokogiri::HTML.parse(@author.avatar)
      link = @avatar_html.at_xpath("//a")

      assert link
      link["href"].must_equal(@author.url)

      image_tag = link.at_xpath("//img")

      assert image_tag
      image_tag["src"].must_equal(@author.absolute_avatar_url)
    end

    it "has no link and the default avatar if author is nil" do
      nil_author = AuthorDecorator.decorate(nil)
      @avatar_html = Nokogiri::HTML.parse(nil_author.avatar)

      link = @avatar_html.at_xpath("//a")
      refute link

      image_tag = @avatar_html.at_xpath("//img")

      assert image_tag
      image_tag["src"].must_equal(nil_author.absolute_avatar_url)
    end
  end

  describe "#absolute_avatar_url" do
    it "uses the author's avatar url if present" do
      avatar_url = "http://example.com/avatar.png"
      @author.image_url = avatar_url

      @author.absolute_avatar_url.must_equal(avatar_url)
    end

    it "creates a gravatar url if avatar url isnt present but email is" do
      @author.email = "some_author_email@example.com"
      @author.absolute_avatar_url.must_match("gravatar.com")
    end

    it "uses the rstat.us default avatar if avatar url isn't specified" do
      @author.email = nil

      @author.absolute_avatar_url.must_equal(
        "/assets/#{RstatUs::DEFAULT_AVATAR}"
      )
    end

    it "uses the rstat.us default avatar if author is nil" do
      nil_author = AuthorDecorator.decorate(nil)
      nil_author.absolute_avatar_url.must_equal(
        "/assets/#{RstatUs::DEFAULT_AVATAR}"
      )
    end
  end
end
