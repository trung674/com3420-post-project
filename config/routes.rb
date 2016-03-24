Rails.application.routes.draw do

  devise_for :mods
    match "/403", to: "errors#error_403", via: :all
    match "/404", to: "errors#error_404", via: :all
    match "/422", to: "errors#error_422", via: :all
    match "/500", to: "errors#error_500", via: :all

    get :ie_warning, to: 'errors#ie_warning'
    get :javascript_warning, to: 'errors#javascript_warning'

    root to: 'pages#home'
    get '/upload', to: 'media#new'
    get '/map', to: 'pages#map'
    get '/search', to: 'search#search'
    get '/about', to: 'pages#about'
    get '/contact', to: 'pages#contact'
    get '/modpanel', to: 'mods#modpanel'
    get '/modlist', to: 'mods#modlist'
    get '/createmod', to: 'mods#new'
    #TODO add routing stuff here!! IMPORTANT TO DO PROPERLY, BUT DON'T KNOW HOW!!!


    resources :media
    resources :recordings, :controller => :media, :type => "Recording"
    resources :documents, :controller => :media, :type => "Document"
    resources :images, :controller => :media, :type => "Image"
    resources :texts, :controller => :media, :type => "Text"


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
