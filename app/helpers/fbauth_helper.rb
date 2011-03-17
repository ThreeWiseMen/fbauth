module FbauthHelper
  def fbauth_login_javascript options={}
    login_el = options[:login] || 'login'
    add_el = options[:add] || 'add'
    ready_el = options[:ready] || 'ready'

    render :partial => '/fbauth/login.html.haml', :locals => { :login_el => login_el, :add_el => add_el, :ready_el => ready_el }
  end

  def fbauth_init_javascript options={}
    render :partial => '/fbauth/init.html.haml', :locals => options.merge(:channel_url => fbauth_build_url('/channel.html'))
  end

  def fbauth_build_url path
    if request.ssl?
      u = "https://"
    else
      u = "http://"
    end
    u += request.host
    u += ":#{request.port}" if request.port != 80
    u += path
  end

  def fbauth
    @facebook_auth
  end
end
