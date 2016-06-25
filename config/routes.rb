require 'que/web'

Rails.application.routes.draw do
  namespace :api, format: false do
    namespace :v1 do
      with_options only: :create do
        resources :conversions
        resources :contacts, path: '/clickfunnels/:api_key/contacts(/:tag)'
      end
    end
  end

  devise_for :accounts, skip: :registrations
  devise_scope :account do
    resource :registration, only: [:new, :create, :edit, :update],
                            path: 'accounts',
                            path_names: { new: 'sign_up' },
                            controller: 'accounts/registrations',
                            as: :account_registration do
                              get :suspend
                              get :activate
                            end
  end

  authenticated :account do
    mount Que::Web => '/que'

    root to: 'dashboard#show', as: :signed_in_root
  end

  root to: 'marketing#index'

  resources :leads, only: :create

  resource :settings, only: [:edit, :update]
  resources :tags, except: :show
  resources :imports, only: [:new, :create]
  resources :domains, only: [:show, :create, :destroy]
  resources :subscribers
  resources :campaigns do
    resource :delivery, only: [:new, :create]
    resource :preview, only: [:show, :create]

    post :duplicate, on: :member
  end

  resources :automations do
    member do
      patch :pause
      patch :resume
    end
  end

  resources :subscriptions, only: :show do
    member do
      get :subscribe
      get :unsubscribe
    end
  end

  post '/funnel_webhooks/test', to: proc { [200, {}, ['']] }
  get '/track/click/:id', to: 'tracks#click'
  get '/track/open/:id', to: 'tracks#open'
end
