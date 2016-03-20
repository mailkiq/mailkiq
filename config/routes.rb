require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1, constraints: { format: :json } do
      resources :notifications, only: [:create]
      jsonapi_resources :subscribers, only: [:create]
    end
  end

  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]
  resources :accounts, controller: 'accounts', only: [:create] do
    resource :password, controller: 'clearance/passwords',
                        only: [:create, :edit, :update]
  end

  get '/sign_up' => 'accounts#new', as: :sign_up
  get '/sign_in' => 'clearance/sessions#new', as: :sign_in
  delete '/sign_out' => 'clearance/sessions#destroy', as: :sign_out

  constraints Clearance::Constraints::SignedIn.new(&:admin?) do
    mount Sidekiq::Web => '/sidekiq'
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: 'dashboard#show', as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'marketing#index'
  end

  scope via: [:get, :put] do
    match '/settings/profile', to: 'settings#profile', as: :profile_settings
    match '/settings/amazon', to: 'settings#amazon', as: :amazon_settings
  end

  resources :tags, except: [:show]
  resources :domains, only: [:create, :destroy]
  resources :subscribers
  resources :campaigns do
    resource :delivery, except: [:edit, :update]
    resource :preview, only: :show
  end

  scope :track do
    resources :opens, only: :show
    resources :clicks, only: :show
  end

  resource :unsubscribe, only: :show

  get 'paypal/checkout', to: 'paypal#checkout'

  # ux improvements
  get '/session', to: redirect('/sign_in')
  get '/accounts', to: redirect('/sign_up')
  get '/passwords', to: redirect('/passwords/new')
  get '/settings', to: redirect('/settings/profile')
end
