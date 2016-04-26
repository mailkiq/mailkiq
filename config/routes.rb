require 'resque/server'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1, constraints: { format: :json } do
      resources :notifications, only: :create
      jsonapi_resources :subscribers, only: :create
    end
  end

  devise_for :accounts, controllers: { registrations: 'accounts/registrations' }

  authenticated :account, -> (account) { account.admin? } do
    mount Resque::Server.new, at: '/resque'
  end

  authenticated :account do
    root to: 'dashboard#show', as: :signed_in_root
  end

  root to: 'marketing#index'

  resources :leads, only: :create

  scope via: [:get, :put] do
    match '/settings/account', to: 'settings#account', as: :account_settings
    match '/settings/domains', to: 'settings#domains', as: :domains_settings
  end

  resources :tags, except: :show
  resources :imports, only: [:new, :create]
  resources :domains, only: [:create, :destroy]
  resources :subscribers
  resources :campaigns do
    resource :delivery, only: [:new, :create]

    member do
      get :preview
      post :duplicate
    end
  end

  scope :track do
    resources :opens, only: :show
    resources :clicks, only: :show
  end

  resource :unsubscribe, only: :show

  get 'paypal/thank_you', to: 'paypal#thank_you'
  get 'paypal/canceled', to: 'paypal#canceled'
  get 'paypal/ipn', to: 'paypal#ipn'
end
