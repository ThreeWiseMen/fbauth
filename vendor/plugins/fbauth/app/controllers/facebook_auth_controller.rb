module FacebookAuthController

  def get_access_token
    facebook_auth_data[:access_token]
  end

  def require_facebook_auth
    @facebook_auth_data = facebook_auth_data
    if @facebook_auth_data.nil?
      redirect_to authentication_url
    end
  end

private

  def facebook_auth_data
    parms = get_parms
    unless parms.nil?
      data = {}
      data[:access_token] = parms['access_token'] if parms.has_key? 'access_token'
      data[:expires] = Time.at(parms['expires'].to_i) if parms.has_key? 'expires'
      data[:uid] = parms['uid'] if parms.has_key? 'uid'
      data[:is_expired] = data[:expires] < Time.now if data.has_key? :expires
      data[:user] = FacebookGraph.call(data[:uid], data[:access_token]) if parms.has_key?('uid') && parms.has_key?('access_token')
      if data[:user].has_key?('error')
        logger.error "Invalid access token, #{data[:user]['error'].inspect}"
        data = nil
      end
    end
    data
  end

  def get_parm key
    parms = get_parms
    value = parms[key] unless parms.nil?
    value
  end

  def get_parms
    parms = parse_parms
    parms = parse_cookie if parms.nil?
    parms
  end

  def parse_parms
    unless params[:session].nil?
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

  def facebook_user(access_token)
    FacebookGraph.call('me', access_token )
  end

end
