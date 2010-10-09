class AuthController < ApplicationController

  def welcome
    @access_token = get_access_token

    @parms = parse_parms
    @cookie = parse_cookie
    @user = facebook_user @access_token
  end

private

  def parse_parms
    unless params[:session].nil?
      parms = JSON.parse(params[:session])
    end
    parms
  end

  def parse_cookie
    cookie = cookies["fbs_114653015261512"]
    unless cookie.nil?
      parms = {}
      cookie.split("&").each do |pair|
        key, value = pair.split("=")
        parms[key] = value
      end
    end
    parms
  end

  def get_access_token
    parms = parse_parms
    parms = parse_cookie if parms.nil?
    parms['access_token'] unless parms.nil?
  end

  def facebook_graph(path, access_token = nil, options = {})
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

  def facebook_user(access_token)
    facebook_graph('me', access_token )
  end

end
