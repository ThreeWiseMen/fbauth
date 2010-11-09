class AuthController < ApplicationController
  include FacebookAuthController

  before_filter :setup_facebook_auth

  def authenticate
  end

private

  def setup_facebook_auth
    @facebook_auth_data = facebook_auth_data
  end

end

