require 'minitest/autorun'
require 'nokogiri'
require 'action_view'

# allow Capybara methods on a result tree fragment of HTML
class String
  def has_xpath?(path)
    !Nokogiri::HTML(self).xpath(path).empty?
  end

  def has_css?(path)
    has_xpath?(Nokogiri::CSS.xpath_for(path).join(' | '))
  end
end

class Date
  def iso8601
    strftime('%F')
  end
end

class FakeTemplate
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Context

  def protect_against_forgery?
    true
  end

  def form_authenticity_token
    2
  end

  def request_forgery_protection_token
    ""
  end

  def path_to_image(source)
    source
  end
end
