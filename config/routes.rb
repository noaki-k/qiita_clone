Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#index'
  namespace :api, format: :json do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :articles
    end
  end
end
