class AuthController < ApplicationController
  include FacebookAuthController

  before_filter :setup_access_token

  def welcome
    @parms = parse_parms
    @cookie = parse_cookie
    @user = facebook_user @access_token
  end

  def setup_access_token
    @access_token = get_access_token
  end

end

