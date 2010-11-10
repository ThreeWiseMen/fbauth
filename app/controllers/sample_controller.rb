class SampleController < ApplicationController
  include FacebookAuthFunctions

  before_filter :require_facebook_auth

end
