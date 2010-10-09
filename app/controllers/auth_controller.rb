class AuthController < ApplicationController

  def welcome
    @access_token = get_access_token

    @parms = parse_parms
    @cookie = parse_cookie
  end

private

  def get_access_token
    parms = parse_parms
    parms = parse_cookie if parms.nil?
    parms[:access_token]
  end

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

end
