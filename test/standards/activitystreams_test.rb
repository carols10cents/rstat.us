require_relative '../acceptance/acceptance_helper'

describe "http://activitystrea.ms/specs/atom/1.0/" do
  include AcceptanceHelper

  it "does stuff" do
    u = Factory(:user)

    visit "/users/#{u.username}/feed"
    puts page.body
  end
end
