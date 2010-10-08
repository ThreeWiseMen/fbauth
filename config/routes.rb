ActionController::Routing::Routes.draw do |map|
<<<<<<< HEAD
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
  
  map.root :controller => :auth, :action => :welcome
=======
  map.root :controller => "public"

  map.registration_form 'registration_form', :controller => :public, :action => :registration_form
  map.register 'register', :controller => :public, :action => :register
  map.members 'members', :controller => :members, :action => :index
  map.resources :people do |person|
    person.resources :memberships do |membership|
      membership.recalculate 'recalculate', :controller => :memberships, :action => :recalculate
      membership.mark_paid 'mark_paid', :controller => :memberships, :action => :mark_paid
    end
  end

  map.login '/login', :controller => :public, :action => :login
  map.logoff '/logoff', :controller => :public, :action => :logoff

  map.connect '/:controller/:action'
>>>>>>> heroku/master
end
