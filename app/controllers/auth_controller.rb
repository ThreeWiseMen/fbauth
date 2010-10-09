class AuthController < ApplicationController

  def welcome
    @access_token = parse_cookie(cookies["fbs_114653015261512"])['access_token']
  end

private

  def parse_cookie(cookie)
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
