Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.failure_app = lambda {|env| SessionsController.action(:new).call(env)}
  manager.oauth(:twitter) do |twitter|
    twitter.consumer_secret = ENV["CONSUMER_KEY"]
    twitter.consumer_key    = ENV["CONSUMER_SECRET"]
    twitter.options :site => 'http://twitter.com'
  end
  manager.default_strategies(:password, :twitter_oauth)
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

Warden::OAuth.access_token_user_finder(:twitter) do |access_token|
  Authorization.where(:oauth_token => access_token.token,
                      :oauth_secret => access_token.secret)
end

Warden::Strategies.add(:password) do
  def authenticate!
    user = User.find_by_case_insensitive_username(params['username'])
    if user
      if user.authenticate(params['password'])
        success! user
      else
        fail "Incorrect password"
      end
    else
      fail "User does not exist yet"
    end
  end
end

Warden::Strategies.add(:twitter_oauth) do
  def authenticate!
  end
end
