ActionController::Routing::Routes.draw do |map|
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
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
    # Creates a named route for the chart.
  map.checkins_per_day_chart '/checkin/checkin_per_day_chart', :controller => 'checkin', :action => 'checkins_per_day_chart'
  
  map.build_time_chart '/build/build_time_chart/:server/:pipeline/:stage', :controller => 'build', :action => 'build_time_chart'
  map.builds_per_day_chart '/build/build_builds_per_day_chart/:server/:pipeline/:stage', :controller => 'build', :action => 'builds_per_day_chart'
  map.build_turnaround_chart '/build/build_turnaround_chart/:server/:pipeline/:stage', :controller => 'build', :action => 'build_turnaround_chart'
  map.build '/build/:server/:pipeline/:stage', :controller => 'build', :action => 'index'
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
