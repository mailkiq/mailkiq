Rails.application.routes.draw do
  root to: 'home#index'

  resource :session, controller: 'clearance/sessions', only: [:create]
  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resources :campaigns
  resources :lists do
    resources :custom_fields, except: [:show, :new]
  end

  scope path: '/accounts/:account_id', as: :account do
    resource :password, controller: 'clearance/passwords',
                        only: [:create, :edit, :update]
  end

  scope via: [:get, :put] do
    match '/settings/profile' => 'settings#profile', as: :profile_settings
    match '/settings/aws' => 'settings#aws', as: :aws_settings
  end

  get '/dashboard' => 'dashboard#index', as: :dashboard

  get '/signup' => 'accounts#new', as: :sign_up
  post '/signup' => 'accounts#create'

  get '/login' => 'clearance/sessions#new', as: :sign_in
  delete '/logout' => 'clearance/sessions#destroy', as: :sign_out

  # ux improvements
  get '/session' => redirect('/login')
  get '/passwords' => redirect('/passwords/new')
  get '/settings' => redirect('/settings/profile')
end
