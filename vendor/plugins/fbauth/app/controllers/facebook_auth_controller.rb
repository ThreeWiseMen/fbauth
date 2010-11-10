module FacebookAuthController

  def setup_facebook_auth
    @facebook_auth ||= facebook_auth
  end

  def require_facebook_auth
    setup_facebook_auth
    if @facebook_auth.nil?
      redirect_to authentication_url
    end
  end

private

  def facebook_auth
    # If we have valid auth in session, use it
    data = parse_session
    unless data.nil?
      auth = FacebookAuth.create(data)
      return auth if auth.validate
    end
    # If no valid session auth, try the cookie from the JS SDK
    data = parse_cookie
    unless data.nil?
      auth = FacebookAuth.create(data)
      return auth if auth.validate
    end
    # If no valid session or cookie auth, last chance try the URL
    data = parse_parms
    unless data.nil?
      auth = FacebookAuth.create(data)
      return auth if auth.validate
    end
  end

  def parse_session
    unless session[:fbauth].nil?
      parms = YAML.parse(session[:fbauth])
    end
    parms
  end

  def parse_parms
    unless params[:session].nil?
      logger.warn "###### URL parms found - #{params[:session].inspect}"
      parms = JSON.parse(params[:session])
    end
    parms
  end

  def parse_cookie
    cookie = cookies["fbs_#{FacebookConfig['app_id']}"]
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
