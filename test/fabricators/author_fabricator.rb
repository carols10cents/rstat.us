Fabricator(:author) do
  feed { |author| Fabricate(:feed, :author => author) }
  username "user"
  email { sequence(:email) { |i| "user_#{i}@example.com" } }
  website "http://example.com"
  domain "foo.example.com"
  name "Something"
  bio "Hi, I do stuff."
end

Fabricator(:remote_author, :from => :author) do
  domain "some_url.com"
  remote_url "some_url.com/#{username}"
end