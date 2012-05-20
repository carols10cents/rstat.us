Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = lambda {|env| SessionsController.action(:new).call(env)}
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
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