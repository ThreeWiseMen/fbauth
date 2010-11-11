module FbauthHelper
  def fbauth_login_javascript options={}
    login_el = options[:login] || 'login'
    add_el = options[:add] || 'add'
    ready_el = options[:ready] || 'ready'

    render :partial => '/fbauth/login.html.haml', :locals => { :login_el => login_el, :add_el => add_el, :ready_el => ready_el }
  end

  def fbauth_init_javascript options={}
    render :partial => '/fbauth/init.html.haml', :locals => { options }
  end

  def fbauth
    @facebook_auth
  end
end
