class AuthController < ApplicationController
  include FacebookAuthController

  def welcome
    @access_token = get_access_token

    @parms = parse_parms
    @cookie = parse_cookie
    @user = facebook_user @access_token
  end

end

