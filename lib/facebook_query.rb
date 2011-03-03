require 'uri'

class FacebookQuery
  include FacebookHttp

  FB_API_URL = "https://api.facebook.com/method/fql.query"

  def self.fql(query, access_token = nil, options = {})
    get FB_API_URL, options.merge({ :format => "JSON", :query => query, :access_token => access_token })
  end
end
