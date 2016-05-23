require 'que/web'

Rails.application.routes.draw do
  namespace :api, format: false do
    namespace :v1 do
      with_options only: :create do
        resources :subscribers
        resources :contacts, path: '/clickfunnels/:api_key/contacts(/:tag)'
      end
    end
  end

  devise_for :accounts, controllers: { registrations: 'accounts/registrations' }

  authenticated :account do
    mount Que::Web => '/que'

    root to: 'dashboard#show', as: :signed_in_root
  end

  root to: 'marketing#index'

  resource :settings, only: [:edit, :update]
  resources :automations
  resources :leads, only: :create
  resources :tags, except: :show
  resources :imports, only: [:new, :create]
  resources :domains, only: [:show, :create, :destroy]
  resources :subscribers
  resources :campaigns do
    resource :delivery, only: [:new, :create]

    member do
      get :preview
      post :duplicate
    end
  end

  post '/funnel_webhooks/test', to: proc { [200, {}, ['']] }
  get '/track/click/:id', to: 'tracks#click'
  get '/track/clicks/:id', to: 'tracks#click'
  get '/track/open/:id', to: 'tracks#open'
  get '/track/opens/:id', to: 'tracks#open'
  get '/unsubscribe', to: 'subscriptions#unsubscribe'
end
