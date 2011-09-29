class UpdatePresenter
  include ActiveSupport

  def initialize(update)
    @update = update
  end

  def whatever
    "<span class='fn'><a class='url' href='#{@update.author.url}'>#{@update.author.display_name} (<span class='nickname'>#{@update.author.username}</span>)</a></span>".html_safe
  end

end