module ApplicationHelper
  def avatar_for(author)
    if author.avatar_url.eql? Author::DEFAULT_AVATAR
      asset_path(author.avatar_url)
    else
      author.avatar_url
    end
  end

  def present(object, klass = nil)
     klass ||= "#{object.class}Presenter".constantize
     presenter = klass.new(object, self)
     yield presenter if block_given?
     presenter
  end
end
