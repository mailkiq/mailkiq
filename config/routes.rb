Rails.application.routes.draw do
  root to: 'home#index'

  get '/login' => 'clearance/sessions#new', as: :sign_in
  get '/signup' => 'accounts#new', as: :sign_up
  post '/signup' => 'accounts#create'
  delete '/logout' => 'clearance/sessions#destroy', as: :sign_out
  get '/dashboard' => 'dashboard#index', as: :dashboard

  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]
  resource :password, controller: 'clearance/passwords',
                      only: [:create, :edit, :update],
                      path: '/accounts/:account_id',
                      as: :account_password

  scope via: [:get, :put] do
    match '/settings/profile' => 'settings#profile', as: :profile_settings
    match '/settings/aws' => 'settings#aws', as: :aws_settings
  end

  resources :campaigns
  resources :templates
  resources :lists do
    resources :custom_fields, except: [:show, :new]
    resources :subscribers, only: [] do
      collection do
        resource :import, only: [:new, :create]
      end
    end
  end

  # ux improvements
  get '/session' => redirect('/login')
  get '/passwords' => redirect('/passwords/new')
  get '/settings' => redirect('/settings/profile')
  get '/lists/:list_id/subscribers/import' =>
    redirect('/lists/%{list_id}/subscribers/import/new')
end
