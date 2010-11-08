module FacebookAuthController

  def get_access_token
    facebook_auth_data[:access_token]
  end

private

  def facebook_auth_data
    parms = get_parms
    unless parms.nil?
      data = {
        :access_token => parms['access_token'],
        :expires => Time.at(parms['expires']),
        :uid => parms['uid']
      }
      data[:is_expired] = data[:expires] < Time.now
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
