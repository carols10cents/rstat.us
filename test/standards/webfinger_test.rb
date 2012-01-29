require_relative '../acceptance/acceptance_helper'

describe "https://code.google.com/p/webfinger/wiki/WebFingerProtocol" do
  include AcceptanceHelper

  describe "host-meta XRD" do
    it "has an lrdd Link with the profile template" do
      visit "/.well-known/host-meta"
      assert has_selector?(:xpath, "//link[@rel='lrdd' and contains(@template, '/users/{uri}/xrd.xml')]")
    end
  end

  describe "user's XRD file" do
    before do
      @u = Factory(:user)
      visit "/users/#{@u.username}/xrd.xml"
    end

    it "has the username and domain as the subject" do
      assert has_selector?(:xpath, "//subject[text()='acct:#{@u.username}@#{@u.author.domain}']")
    end

    it "has aliases for the profile URLs" do
      assert has_selector?(:xpath, "//alias[contains(text(), '/feeds/#{@u.feed.id}')]")
      assert has_selector?(:xpath, "//alias[contains(text(), '/users/#{@u.username}')]")
    end
  end
end
