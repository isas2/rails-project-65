# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    namespace :admin do
      root to: 'bulletins#index_moderated'
      resources :categories, only: %i[create edit destroy index new show update]
      resources :bulletins, only: [:index] do
        member do
          patch :archive
          patch :publish
          patch :reject
        end
      end
    end

    root to: 'bulletins#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete '/logout', to: 'auth#delete'
    get '/profile', to: 'bulletins#profile'
    resources :bulletins, only: %i[create edit index new show update] do
      member do
        patch :archive
        patch :to_moderate
      end
    end
  end
end
