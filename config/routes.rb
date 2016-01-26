Rails.application.routes.draw do
  root to: 'home#index'

  get '/login', to: 'clearance/sessions#new', as: :sign_in
  get '/signup', to: 'accounts#new', as: :sign_up
  post '/signup', to: 'accounts#create'
  delete '/logout', to: 'clearance/sessions#destroy', as: :sign_out
  get '/dashboard', to: 'dashboard#index', as: :dashboard

  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]
  resource :password, controller: 'clearance/passwords',
                      only: [:create, :edit, :update],
                      path: '/accounts/:account_id',
                      as: :account_password

  scope via: [:get, :put] do
    match '/settings/profile', to: 'settings#profile', as: :profile_settings
    match '/settings/aws', to: 'settings#aws', as: :aws_settings
  end

  resources :bounces, only: [:create]
  resources :campaigns
  resources :templates
  resources :subscribers

  # ux improvements
  get '/session', to: redirect('/login')
  get '/passwords', to: redirect('/passwords/new')
  get '/settings', to: redirect('/settings/profile')
end
