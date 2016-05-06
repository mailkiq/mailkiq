require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      jsonapi_resources :subscribers, only: :create
      scope :clickfunnels do
        jsonapi_resources :contacts, only: :create
      end
    end
  end

  devise_for :accounts, controllers: { registrations: 'accounts/registrations' }

  authenticated :account do
    mount Sidekiq::Web => '/sidekiq'

    root to: 'dashboard#show', as: :signed_in_root
  end

  scope via: [:get, :put] do
    match '/settings/account', to: 'settings#account', as: :account_settings
    match '/settings/domains', to: 'settings#domains', as: :domains_settings
  end

  root to: 'marketing#index'

  resources :leads, only: :create
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

  post '/funnel_webhooks/test', to: proc { [200, {}, ['']] }
  get '/track/click/:id' => 'tracks#click'
  get '/track/clicks/:id' => 'tracks#click'
  get '/track/open/:id' => 'tracks#open'
  get '/track/opens/:id' => 'tracks#open'
  get '/unsubscribe' => 'subscriptions#unsubscribe'
end
