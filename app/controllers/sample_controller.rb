class SampleController < ApplicationController
  include FacebookAuthController

  before_filter :require_facebook_auth

end
