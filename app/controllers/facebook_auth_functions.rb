module FacebookAuthFunctions

  SESSION_KEY = :fbauth
  OLD_FB_SESSION_PARAMS_KEY = :session
  FB_SIGNED_REQUEST_KEY = :signed_request

  def setup_facebook_auth auth=nil
    @facebook_auth = auth ||= facebook_auth
  end

  def require_facebook_auth
    setup_facebook_auth
    if @facebook_auth.nil?
      redirect_to build_auth_url
    end
    if signed_params_present? && request.post?
      # If Facebook POST with signed_params, redirect to original URI using GET
      redirect_to request.request_uri
    end
  end

private

  def build_auth_url
    "#{request.protocol}#{request.host_with_port}#{FacebookConfig['auth_path']}"
  end

  def facebook_auth
    # Prep IE so it will take our cookies in a Facebook iFrame
    response.headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'

    # Parms will always hold the most up-to-date session data
    data = parse_parms
    auth = validate_and_save(data) unless data.nil?
    return auth unless auth.nil?

    # If no auth params, and we have valid auth in session, use it
    data = parse_session
    auth = validate_and_save(data) unless data.nil?
    return auth unless auth.nil?
    # Clear session variable if its data was bad
    clear_session

    # If no valid session auth or params auth, last chance try the cookie set by the JS SDK
    data = parse_cookie
    auth = validate_and_save(data) unless data.nil?
    return auth unless auth.nil?

    logger.warn("Unable to parse any security params for request - cold authentication required")
    nil
  end

  def validate_and_save data
    auth = FacebookAuth.create(data)
    if auth.validate
      session[SESSION_KEY] = auth.session_data
      return auth
    else
      logger.warn("Auth parameters didn't validate (#{auth.validation_error})")
      return nil
    end
  end

  def old_params_present?
    params[OLD_FB_SESSION_PARAMS_KEY].present?
  end

  def signed_params_present?
    params[FB_SIGNED_REQUEST_KEY].present?
  end

  def parse_parms
    if old_params_present?
      parms = JSON.parse(params[OLD_FB_SESSION_PARAMS_KEY])
      logger.warn("Parsed facebook params from session parameter (deprecated)")
    elsif signed_params_present?
      logger.warn("Found signed_request param")
      begin
        parms = FacebookDecoder.decode(params[FB_SIGNED_REQUEST_KEY])
        logger.warn("Parsed facebook params from signed_request parameter")
      rescue => e
        logger.warn("Error with signed_request data: #{e}")
      end
    end
    parms
  end

  def parse_session
    unless session[SESSION_KEY].nil?
      begin
        parms = JSON.parse(session[SESSION_KEY])
        logger.warn("Parsed facebook params from existing rails session")
      rescue => e
        logger.warn("Error parsing params from session - #{e}\n    from #{session[SESSION_KEY]}")
        clear_session
      end
    end
    parms
  end

  def clear_session
    session[SESSION_KEY] = nil
  end

  def parse_cookie
    cookie = cookies["fbs_#{FacebookConfig['app_id']}"]
    unless cookie.nil?
      parms = {}
      cookie = cookie.gsub(/^"/, '').gsub(/"$/, '')
      cookie.split("&").each do |pair|
        key, value = pair.split("=")
        parms[key] = value
      end
      logger.warn("Parsed facebook params from cookie - #{cookie.inspect}\n    found #{parms.inspect}")
    end
    parms
  end

end
