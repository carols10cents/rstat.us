require_relative '../acceptance/acceptance_helper'

describe "http://ostatus.org/sites/default/files/ostatus-1.0-draft-1-specification_0.html" do
  include AcceptanceHelper

  describe "discovery" do
    it "can discover the location of the feed from a link in a profile pg" do
      u = Factory(:user)

      visit "/users/#{u.username}"
      assert has_selector?(:xpath, "//link[@rel='alternate' and @type='application/atom+xml' and @href]")
    end

    it "can discover a profile page url of a related XRD file" do
      u = Factory(:user)

      visit "/users/#{u.username}/xrd.xml"
      assert has_selector?(:xpath, "//link[@rel='http://webfinger.net/rel/profile-page' and contains(@href, '/users/#{u.username}')]")
    end
  end
end