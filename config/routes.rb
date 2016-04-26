Rails.application.routes.draw do

  resources :links
  devise_for :mods
  mount Mercury::Engine => '/'
    match "/403", to: "errors#error_403", via: :all
    match "/404", to: "errors#error_404", via: :all
    match "/422", to: "errors#error_422", via: :all
    match "/500", to: "errors#error_500", via: :all

    get :ie_warning, to: 'errors#ie_warning'
    get :javascript_warning, to: 'errors#javascript_warning'

    root to: 'pages#home'
    get '/upload', to: 'media#new'
    get '/map', to: 'pages#map'
    get '/search', to: 'pages#search'
    post 'report', to: 'reports#new'
    get '/report', to: 'pages#home'
    get '/about', to: 'pages#about'
    put '/about', to: 'pages#mercury_update_about'
    put '/', to: 'pages#mercury_update_homepage'
    get '/modpanel', to: 'mods#modpanel'
    get '/modlist', to: 'mods#modlist'
    get '/modedit', to: 'mods#modedit'
    get '/contacts/edit', to: 'contacts#edit'
    put '/contacts/update', to: 'contacts#update'
    post '/modedit', to: 'mods#update', as: :mods

    match '/contacts', to: 'contacts#new', via: 'get'


    #TODO add routing stuff here!! IMPORTANT TO DO PROPERLY, BUT DON'T KNOW HOW!!!
    resources 'reports', only: [:new, :create]
    resources "contacts", only: [:new, :create]
    resources :events
    resources :wallpapers
    resources :media do
      get :show_upload, on: :member
      get :show_transcript, on: :member
      member do
        get :approve
      end
    end

    resources :links
    resources :recordings, :controller => :media, :type => "Recording"
    resources :documents, :controller => :media, :type => "Document"
    resources :images, :controller => :media, :type => "Image"
    resources :texts, :controller => :media, :type => "Text"
    resources :pages do
      member { post :mercury_update_about, :mercury_update_homepage }
    end

end
