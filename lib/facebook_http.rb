require 'net/http'
require 'uri'
require 'cgi'

module FacebookHttp

  def get(url, params = {})
    uri = URI.parse(url + build_query_string(params))
    http = Net::HTTP.new uri.host, uri.port
    begin
      http.use_ssl = (uri.scheme == "https")
      req = Net::HTTP::Get.new(uri.path)
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

  def build_query_string options={}
    params = []
    options.each do |key,value|
      params << "#{key.to_s}=#{CGI::escape(value.to_s)}" unless value.nil?
    end
    "?#{params.join('&')}" unless params.empty?
  end
end
