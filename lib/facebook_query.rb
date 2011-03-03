require 'uri'

class FacebookQuery
  include FacebookHttp

  FB_API_URL = "https://api.facebook.com/method/fql.query"

  def initialize(access_token = nil, options = {})
    @options = options.merge({ :access_token => access_token })
    @options.merge!({ :format => "JSON" }) unless @options.has_key?(:format)
  end

  def fql(query, access_token = nil, options = {})
    get FB_API_URL, merged_options(options.merge({ :query => query }))
  end
end
