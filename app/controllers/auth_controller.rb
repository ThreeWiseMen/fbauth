class AuthController < ApplicationController

  def welcome
    fb_parms = parse_cookie(cookies["fbs_114653015261512"])
    @access_token = fb_parms['access_token'] unless fb_parms.nil?
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
