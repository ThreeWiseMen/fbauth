module FacebookAuthFunctions

  def setup_facebook_auth
    @facebook_auth ||= facebook_auth
  end

  def require_facebook_auth
    # Prep IE so it will take our cookies in a Facebook iFrame
    response.headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'

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
    # If we have valid auth in session, use it
    data = parse_session
    auth = validate_and_save(data) unless data.nil?
    return auth unless auth.nil?
    # Clear session variable if its data was bad
    session[:fbauth] = nil

    # If no valid session auth, try the cookie from the JS SDK
    data = parse_cookie
    auth = validate_and_save(data) unless data.nil?
    return auth unless auth.nil?

    # If no valid session or cookie auth, last chance try the URL
    data = parse_parms
    auth = validate_and_save(data) unless data.nil?
    return auth
  end

  def validate_and_save data
    auth = FacebookAuth.create(data)
    if auth.validate
      session[:fbauth] = auth.session_data
      return auth
    else
      return nil
    end
  end

  def parse_session
    unless session[:fbauth].nil?
      begin
        parms = JSON.parse(session[:fbauth])
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
      sig, b64udata = params[:signed_request].split('.')
      json = b64udata.tr('-_', '+/').unpack('m')[0]
      begin
        parms = JSON.parse(json)
      rescue => e
        begin
          parms = JSON.parse(json + '"}')
        rescue => e2
          begin
            parms = JSON.parse(json + '}')
          rescue => e3
            parms = {}
          end
        end
      end
      logger.warn("Parsed facebook params from signed_request parameter")
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
