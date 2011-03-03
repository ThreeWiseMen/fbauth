require 'net/http'
require 'uri'

class FacebookGraph
  include FacebookHttp

  FB_GRAPH_URL = "https://graph.facebook.com"

  def self.call(path, access_token = nil, options = {})
    get FB_GRAPH_URL + "/" + path, options.merge!({:access_token => access_token})
  end

  # Available options:
  #   message, picture, link, name, caption, description
  def self.publish_to_member_feed(uid, access_token, options)
    token = access_token ? CGI::escape(access_token) : nil
    if %w{staging production}.include? ENV['RAILS_ENV']
      url = "#{FB_GRAPH_URL}/#{uid}/feed&access_token=#{token}"
      uri = URI.parse(url)
      http = Net::HTTP.new uri.host, uri.port
      begin
        http.use_ssl = (uri.scheme == "https")
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data(options)
        response = http.request(req)
        raise "Facebook error response #{response.code} - #{response.body}" unless response.code == '200'
        begin
          json = JSON.parse(response.body)
        rescue => e
          raise "Error parsing Facebook response: #{response.body}"
        end
      ensure
        http.finish if http.started?
      end
      json
    end
  end
end
