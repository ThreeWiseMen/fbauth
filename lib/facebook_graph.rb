require 'net/http'
require 'uri'

class FacebookGraph
  include FacebookHttp

  FB_GRAPH_URL = "https://graph.facebook.com"

  def initialize(access_token = nil, options = {})
    @options = options.merge({ :access_token => access_token })
  end

  # Generic Graph call to lookup data for any path
  def call(path, options = {})
    get "#{FB_GRAPH_URL}/#{path}", merged_options(options)
  end

  # Post item to member's wall
  #   Available options: message, picture, link, name, caption, description
  def publish_to_member_feed(uid, options)
    raise "access_token required" unless has_access_token?(options)
    if %w{staging production}.include? ENV['RAILS_ENV']
      post "#{FB_GRAPH_URL}/#{uid}/feed", merged_options(options)
    end
  end
end
