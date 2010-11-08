require 'net/http'
require 'uri'

class FacebookGraph

  def self.call(path, access_token = nil, options = {})
    params = []
    options.keys.each do |k|
      params << "#{k}=#{options[k]}" unless options[k].nil?
    end
    token = access_token ? CGI::escape(access_token) : nil
    url = "https://graph.facebook.com/#{path}&access_token=#{token}"
    url = "#{url}?#{params.join('&')}" unless params.empty?
    uri = URI.parse(url)
    http = Net::HTTP.new uri.host, uri.port
    begin
      http.use_ssl = (uri.scheme == "https")
      req = Net::HTTP::Get.new(uri.path)
      response = http.request(req)
      json = JSON.parse(response.body)
    ensure
      http.finish if http.started?
    end
    json
  end

  # Available options:
  #   message, picture, link, name, caption, description
  def self.publish_to_member_feed(uid, access_token, options)
    token = access_token ? CGI::escape(access_token) : nil
    if %w{staging production}.include? ENV['RAILS_ENV']
      url = "https://graph.facebook.com/#{uid}/feed&access_token=#{token}"
      uri = URI.parse(url)
      http = Net::HTTP.new uri.host, uri.port
      begin
        http.use_ssl = (uri.scheme == "https")
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data(options)
        response = http.request(req)
        json = JSON.parse(response.body)
      ensure
        http.finish if http.started?
      end
      json
    end
  end
end
