module FbauthHelper
 def fbauth_javascript options={}
  login_el = options[:login] || 'login'
  add_el = options[:add] || 'add'
  ready_el = options[:ready] || 'ready'

  render :partial => '/fbauth/javascript.html.haml', :locals => { :login_el => login_el, :add_el => add_el, :ready_el => ready_el }
 end
end
