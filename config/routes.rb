Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#index'

  # reload 対策
  get 'sign_up', to: 'homes#index'
  get 'sign_in', to: 'homes#index'
  get 'articles/new', to: 'homes#index'
  get 'drafts', to: 'homes#index'
  get 'drafts/:id/edit', to: 'homes#index'
  get 'articles/:id', to: 'homes#index'
  get 'mypage', to: 'homes#index'

  namespace :api, format: :json do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations',
        sessions: 'api/v1/auth/sessions'
      }
      get '/mypage', to: 'mypage#index'
      get '/drafts', to: 'drafts#index'
      get '/drafts/:id/edit', to: 'drafts#show'
      resources :articles
    end
  end
end
