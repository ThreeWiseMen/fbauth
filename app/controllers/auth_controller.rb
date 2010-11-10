class AuthController < ApplicationController
  include FacebookAuthController

  # Do we even need this when using the JS SDK for auth?
  before_filter :setup_facebook_auth

  def authenticate
  end

end

