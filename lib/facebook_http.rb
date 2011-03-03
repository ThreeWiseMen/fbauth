require 'net/http'
require 'uri'
require 'cgi'

module FacebookHttp

  def build_get_url(url, params = {})
    q = build_query_string(params)
    if q
      url + q
    else
      url
    end
  end

  def get(url, params = {})
    uri = URI.parse(build_get_url(url, params))
    http = Net::HTTP.new uri.host, uri.port
    begin
      http.use_ssl = (uri.scheme == "https")
      req = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(req)
      raise "Facebook error response #{response.code} - #{response.body}" unless response.code == '200'
      begin
        json = JSON.parse(response.body)
      rescue => e
        raise "Error parsing facebook response: #{response.body}"
      end
    ensure
      http.finish if http.started?
    end
    json
  end

  def post(url, params = {})
    uri = URI.parse(url)
    http = Net::HTTP.new uri.host, uri.port
    begin
      http.use_ssl = (uri.scheme == "https")
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(params)
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

  def build_query_string options={}
    params = []
    str_keys = options.keys.collect{ |k| k.to_s }
    str_keys.sort.each do |str_key|
      key = str_key.to_sym
      value = options[key]
      params << "#{key.to_s}=#{URI.escape(value.to_s)}" unless value.nil?
    end
    "?#{params.join('&')}" unless params.empty?
  end

  def merged_options(options = {})
    options.merge!(@options) if @options
    options
  end

  def has_access_token?(options = {})
    merged_options.has_key :access_token
  end
end
