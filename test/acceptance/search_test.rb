require 'require_relative' if RUBY_VERSION[0,3] == '1.8'
require_relative 'acceptance_helper'

describe "search" do
  include AcceptanceHelper

  before do
    @update_text = "These aren't the droids you're looking for!"
    Factory(:update, :text => @update_text)
  end

  describe "logged in" do
    it "has a link to search when you're logged in" do
      u = Factory(:user, :email => "some@email.com", :hashed_password => "blerg")
      log_in_email(u)

      visit "/"

      assert has_link? "Search"
    end

    it "allows access to the search page" do
      visit "/search"

      assert_equal 200, page.status_code
      assert_match "/search", page.current_url
    end

    it "allows access to search" do
      visit "/search"

      fill_in "q", :with => "droids"
      click_button "Search"

      within search_results do
        assert has_content? @update_text
      end
    end
  end

  describe "anonymously" do
    it "allows access to the search page" do
      visit "/search"

      assert_equal 200, page.status_code
      assert_match "/search", page.current_url
    end

    it "allows access to search" do
      visit "/search"

      fill_in "q", :with => "droids"
      click_button "Search"

      within search_results do
        assert has_content? @update_text
      end
    end
  end

  describe "behavior regardless of authenticatedness" do
    it "has the updates scope selected by default" do
      visit "/search"

      assert has_select?("scope")

      assert has_select?("scope",
                         :options => ["updates", "users"],
                         :selected => "updates")
    end

    it "gets a match for a word in the update" do
      visit "/search"

      fill_in "q", :with => "droids"
      click_button "Search"

      within search_results do
        assert has_content? @update_text
      end
    end

    it "doesn't get a match for a substring ending a word in the update" do
      visit "/search"

      fill_in "q", :with => "roids"
      click_button "Search"

      within search_results do
        assert has_content? "No statuses match your search."
      end
    end

    it "doesn't get a match for a substring starting a word in the update" do
      visit "/search"

      fill_in "q", :with => "loo"
      click_button "Search"

      within search_results do
        assert has_content? "No statuses match your search."
      end
    end

    it "gets a case-insensitive match for a word in the update" do
      visit "/search"

      fill_in "q", :with => "DROIDS"
      click_button "Search"

      within search_results do
        assert has_content? @update_text
      end
    end

    it "does not find users when you search for updates" do
    end
  end

  describe "searching for users" do
    before do
      @user = Factory(:user, :username => "donknuth")
    end

    it "does find users with an exact match" do
      visit "/search"

      fill_in "q", :with => "donknuth"
      select "users"
      click_button "Search"

      within search_results do
        assert has_content? @user.username
      end
    end

    it "does find users with a substring match" do
    end

    it "does find users with a case-insensitive match" do
    end

    it "has a nice message when there are no user matches" do
    end

    it "doesn't find updates when you search for users" do
    end
  end
end
