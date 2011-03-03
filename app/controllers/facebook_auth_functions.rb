module FacebookAuthFunctions

  def setup_facebook_auth
    @facebook_auth ||= facebook_auth
  end

  def require_facebook_auth
    setup_facebook_auth
    if @facebook_auth.nil?
      redirect_to build_auth_url
    end
  end

private

  def build_auth_url
    "#{request.protocol}#{request.host_with_port}#{FacebookConfig['auth_path']}"
  end

  def facebook_auth
    # Prep IE so it will take our cookies in a Facebook iFrame
    response.headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'

    # If we have valid auth in session, use it
    data = parse_session
    auth = validate_and_save(data) unless data.nil?
    return auth unless auth.nil?
    # Clear session variable if its data was bad
    session[:fbauth] = nil

    # If no valid session, try the URL params (session, signed_reuest)
    data = parse_parms
    auth = validate_and_save(data) unless data.nil?
    return auth unless auth.nil?

    # If no valid session auth or params auth, last chance try the JS SDK
    data = parse_cookie
    auth = validate_and_save(data) unless data.nil?

    logger.warn("Unable to parse any security params for request - cold authentication required")

    return auth
  end

  def validate_and_save data
    auth = FacebookAuth.create(data)
    if auth.validate
      session[:fbauth] = auth.session_data
      return auth
    else
      logger.warn("Auth parameters didn't validate (#{auth.validation_error})")
      return nil
    end
  end

  def parse_session
    unless session[:fbauth].nil?
      begin
        parms = JSON.parse(session[:fbauth])
        logger.warn("Parsed facebook params from existing rails session")
      rescue => e
        session[:fbauth] = nil
      end
    end
    parms
  end

  def parse_parms
    if params[:session].present?
      parms = JSON.parse(params[:session])
      logger.warn("Parsed facebook params from session parameter (deprecated)")
    elsif params[:signed_request].present?
      logger.warn("Found signed_request param")
      begin
        parms = FacebookDecoder.decode(params[:signed_request])
        logger.warn("Parsed facebook params from signed_request parameter")
      rescue => e
        logger.warn("Error with signed_request data: #{e}")
      end
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
      logger.warn("Parsed facebook params from cookie")
    end
    parms
  end

end
