class AuthController < ApplicationController
  include FacebookAuthController

  before_filter :setup_facebook_auth

  def welcome
    @parms = parse_parms
    @cookie = parse_cookie
    @user = facebook_user @facebook_auth_data[:access_token]
  end

  def authenticate
  end

private

  def setup_facebook_auth
    @facebook_auth_data = facebook_auth_data
  end

end

