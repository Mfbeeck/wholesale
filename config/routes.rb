Rails.application.routes.draw do

  root 'deals#index'

  get '/new_supplier_session' => 'sessions#new_supplier'

  get '/new_consumer_session' => 'sessions#new_consumer'

  get '/suppliers/about' => 'suppliers#about'


  get '/deals/:id/checkout' => 'deals#checkout', as: :checkout

  post '/deals/:deal_id/orders/new' => 'orders#create', as: :create

  post '/login_supplier' => 'sessions#login_supplier'

  post '/login_consumer' => 'sessions#login_consumer'

  post 'orders/send_message' => 'orders#send_message'

  post '/deals/:deal_id/create_points_order' => 'orders#create_points_order', as: :create_points_order


  resources :charges

  resource :sessions

  resources :orders

  resources :deals do
    resources :orders
  end

  resources :consumers do
    resources :orders
  end

  resources :suppliers do
    resources :deals
  end

  resources :deals do
    resources :comments
  end


  delete 'logout' => 'sessions#destroy'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
