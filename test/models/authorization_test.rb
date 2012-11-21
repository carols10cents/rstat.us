require_relative '../test_helper'

describe Authorization do
  include TestHelper

  it "can be found from a hash" do
    u = Fabricate(:user)
    a = Fabricate(:authorization, :user => u)

    assert_equal a, Authorization.find_from_hash(auth_response(u.username, {:uid => a.uid}))
  end

  it "can be created from a hash" do
    u = Fabricate(:user)
    auth = auth_response(u.username)
    a = Authorization.create_from_hash!(auth, "/", u)

    assert_equal auth["uid"], a.uid
    assert_equal auth["provider"], a.provider
    assert_equal auth["info"]["nickname"], a.nickname
    assert_equal auth['credentials']['token'], a.oauth_token
    assert_equal auth['credentials']['secret'], a.oauth_secret
  end

  it "is not valid without a uid" do
    a = Authorization.new(:uid => nil, :provider => "twitter")

    refute a.valid?
    a.errors[:uid].must_equal ["can't be blank"]
  end

  it "is not valid without a provider" do
    a = Authorization.new(:uid => 12345, :provider => nil)

    refute a.valid?
    a.errors[:provider].must_equal ["can't be blank"]
  end
end
